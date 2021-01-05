//
//  MonkeyParser.swift
//  rosetta
//
//  Created by Franklin Cruz on 01-01-21.
//

import Foundation

enum MonkeyPrecedence: Int {
    case lowest
    case equals // ==
    case lessGreater // > or <
    case sum // +
    case product // *
    case prefix // -X, !X
    case call // function(...)
}

struct MonkeyParser: Parser {
    static let precedences: [Token.Kind: MonkeyPrecedence] = [
        .equals: .equals,
        .notEquals: .equals,
        .lt: .lessGreater,
        .gt: .lessGreater,
        .plus: .sum,
        .minus: .sum,
        .slash: .product,
        .asterisk: .product
    ]

    var lexer: Lexer

    var currentToken: Token?
    var currentPrecendece: Int {
        (MonkeyParser.precedences[currentToken?.type ?? .ilegal] ?? .lowest).rawValue
    }
    var nextToken: Token?
    var nextPrecendece: Int {
        (MonkeyParser.precedences[nextToken?.type ?? .ilegal] ?? .lowest).rawValue
    }

    var prefixParser: PrefixParser
    var infixParser: InfixParser

    init(lexer: Lexer) {
        self.lexer = lexer
        let expressionParser = ExpressionParser()
        self.prefixParser = expressionParser
        self.infixParser = expressionParser
    }

    mutating func parseProgram() throws -> Program? {
        var errors: [ParseError] = []
        var program = Program(statements: [])

        while self.currentToken?.type != .eof {
            do {
                if let statement = try self.parseStatement() {
                    program.statements.append(statement)
                }
            } catch let error as ParseError {
                errors.append(error)
            }
            self.readToken()
        }

        guard errors.count == 0 else {
            throw AllParserError(withErrors: errors)
        }

        return program
    }

    mutating func parseStatement() throws -> Statement? {
        guard let token = self.currentToken else {
            return nil
        }

        switch token.type {
        case Token.Kind.let:
            return try parseLetStatement()
        case Token.Kind.return:
            return try parseReturnStatement()
        default:
            return try parseExpressionStatement()
        }
    }

    mutating func parseLetStatement() throws -> LetStatement? {
        guard let token = self.currentToken, token.type == .let else {
            return nil
        }

        try expectNext(toBe: .identifier)
        let identifierToken = self.currentToken!
        let name = Identifier(token: identifierToken, value: identifierToken.literal)

        try expectNext(toBe: .assign)

        while self.currentToken?.type != .semicolon {
            self.readToken()
        }

        return LetStatement(token: token, name: name, value: Dummy())
    }

    mutating func parseReturnStatement() throws -> ReturnStatement? {
        guard let token = self.currentToken, token.type == .return else {
            return nil
        }

        while self.currentToken?.type != .semicolon {
            self.readToken()
        }

        return ReturnStatement(token: token, value: Dummy())
    }

    mutating func parseExpressionStatement() throws -> ExpressionStatement? {
        guard let token = self.currentToken else {
            return nil
        }

        guard let expression = try parseExpression(withPrecedence: MonkeyPrecedence.lowest.rawValue) else {
            return nil
        }

        if self.nextToken?.type == .semicolon {
            self.readToken()
        }

        return ExpressionStatement(token: token, expression: expression)
    }

    mutating func parseExpression(withPrecedence precedence: Int) throws -> Expression? {
        var leftExpression = try self.prefixParser.parse(&self)
        guard leftExpression != nil else {
            return nil
        }

        while self.nextToken?.type != .semicolon && precedence < self.nextPrecendece {
            self.readToken()
            leftExpression = try self.infixParser.parse(&self, lhs: leftExpression!)
        }

        return leftExpression
    }

    /// Temporal struct just to use a placeholder while we
    /// implement expression parsing
    struct Dummy: Expression {
        var literal: String
        var token: Token

        init() {
            self.literal = ""
            self.token = Token(type: .eof, literal: "")
        }

        var description: String {
            "<Expression Placeholder>"
        }
    }
}

extension Parser {
    /// This method belongs  to `MonkeyParser` because is not generic to any language
    /// however to avoid unnecesary complexity with the mutability inside the prefix and
    /// infix parser I have decided to add it as an extension of the generic `Parser` `protocol`
    mutating func parseBlockStatement() throws -> BlockStatement? {
        guard let token = self.currentToken, token.type == .lbrace else {
            return nil
        }

        var statements: [Statement] = []
        self.readToken()
        while self.currentToken?.type != .rbrace && self.currentToken?.type != .eof {
            if let statement = try self.parseStatement() {
                statements.append(statement)
            }
            self.readToken()
        }

        return BlockStatement(token: token, statements: statements)
    }
}

struct ExpressionParser: PrefixParser, InfixParser {
    func parse<P>(_ parser: inout P) throws -> Expression? where P: Parser {
        guard let token = parser.currentToken else {
            return nil
        }

        switch token.type {
        case Token.Kind.identifier:
            return try parseIdentifier(&parser)
        case Token.Kind.int:
            return try parseInteger(&parser)
        case Token.Kind.bang, Token.Kind.minus:
            return try parsePrefix(&parser)
        case Token.Kind.true, Token.Kind.false:
            return try parseBoolean(&parser)
        case Token.Kind.lparen:
            return try parseGroupedExpression(&parser)
        case Token.Kind.if:
            return try parseIfExpression(&parser)
        default:
            throw MissingPrefixFunc(token: token)
        }
    }

    func parse<P>(_ parser: inout P, lhs: Expression) throws -> Expression? where P: Parser {
        guard let token = parser.currentToken else {
            return nil
        }

        let precedence = parser.currentPrecendece
        parser.readToken()
        guard let rhs = try parser.parseExpression(withPrecedence: precedence) else {
            // TODO: Throw the right error
            return nil
        }

        return InfixExpression(token: token, lhs: lhs, operatorSymbol: token.literal, rhs: rhs)
    }

    func parseIdentifier<P>(_ parser: inout P) throws -> Expression? where P: Parser {
        guard let token = parser.currentToken, token.type == .identifier else {
            return nil
        }

        return Identifier(token: token, value: token.literal)
    }

    func parseInteger<P>(_ parser: inout P) throws -> Expression? where P: Parser {
        guard let token = parser.currentToken, token.type == .int else {
            return nil
        }

        return try IntegerLiteral(token: token)
    }

    func parseBoolean<P>(_ parser: inout P) throws -> Expression? where P: Parser {
        guard let token = parser.currentToken, token.type == .true || token.type == .false else {
            return nil
        }

        return try BooleanLiteral(token: token)
    }

    func parseGroupedExpression<P>(_ parser: inout P) throws -> Expression? where P: Parser {
        guard let token = parser.currentToken, token.type == .lparen else {
            return nil
        }

        parser.readToken()
        let expression = try parser.parseExpression(withPrecedence: MonkeyPrecedence.lowest.rawValue)

        try parser.expectNext(toBe: .rparen)
        return expression
    }

    func parseIfExpression<P>(_ parser: inout P) throws -> Expression? where P: Parser {
        guard let token = parser.currentToken, token.type == .if else {
            return nil
        }

        try parser.expectNext(toBe: .lparen)

        parser.readToken()

        guard let condition = try parser.parseExpression(withPrecedence: MonkeyPrecedence.lowest.rawValue) else {
            return nil
        }

        try parser.expectNext(toBe: .rparen)
        try parser.expectNext(toBe: .lbrace)

        guard let consequence = try parser.parseBlockStatement() else {
            return nil
        }

        var alternative: BlockStatement?
        if parser.nextToken?.type == .else {
            parser.readToken()

            try parser.expectNext(toBe: .lbrace)
            alternative = try parser.parseBlockStatement()
        }

        return IfExpression(
            token: token,
            condition: condition,
            consequence: consequence,
            alternative: alternative
        )
    }

    func parsePrefix<P>(_ parser: inout P) throws -> Expression? where P: Parser {
        guard let token = parser.currentToken, token.type == .bang || token.type == .minus else {
            return nil
        }

        parser.readToken()

        guard let rhs = try parser.parseExpression(withPrecedence: MonkeyPrecedence.prefix.rawValue) else {
            // TODO: Throw the right error
            return nil
        }

        return PrefixExpression(token: token, operatorSymbol: token.literal, rhs: rhs)
    }
}
