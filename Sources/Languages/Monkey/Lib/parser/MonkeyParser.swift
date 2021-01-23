//
//  MonkeyParser.swift
//  rosetta
//
//  Created by Franklin Cruz on 01-01-21.
//

import Foundation
import Rosetta

enum MonkeyPrecedence: Int {
    case lowest
    case equals // ==
    case lessGreater // > or < or <= or >=
    case sum // +
    case product // *
    case prefix // -X, !X
    case call // function(...)
    case index // array[index]
}

public struct InvalidExpression: ParseError {
    public var message: String
    public var line: Int?
    public var column: Int?

    public init(_ token: Token?, line: Int? = nil, column: Int? = nil) {
        self.message = "Can't parse expression starting at: \(token?.literal ?? "")"
        self.line = line ?? token?.line
        self.column = column ?? token?.column
    }
}

public struct MonkeyParser: Parser {
    static let precedences: [Token.Kind: MonkeyPrecedence] = [
        .equals: .equals,
        .notEquals: .equals,
        .lt: .lessGreater,
        .gt: .lessGreater,
        .lte: .lessGreater,
        .gte: .lessGreater,
        .plus: .sum,
        .minus: .sum,
        .slash: .product,
        .asterisk: .product,
        .lparen: .call,
        .lbracket: .index
    ]

    public var lexer: Lexer

    public var currentToken: Token?
    public var currentPrecendece: Int {
        (MonkeyParser.precedences[currentToken?.type ?? .ilegal] ?? .lowest).rawValue
    }
    public var nextToken: Token?
    public var nextPrecendece: Int {
        (MonkeyParser.precedences[nextToken?.type ?? .ilegal] ?? .lowest).rawValue
    }

    public var prefixParser: PrefixParser
    public var infixParser: InfixParser

    public init(lexer: Lexer) {
        self.lexer = lexer
        self.prefixParser = MonkeyPrefixParser()
        self.infixParser = MonkeyInfixParser()
    }

    public mutating func parseProgram() throws -> Program? {
        var errors: [ParseError] = []
        var program = Program(statements: [])

        self.currentToken = self.lexer.nextToken()
        self.nextToken = self.lexer.nextToken()
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

        guard errors.isEmpty else {
            throw AllParserError(withErrors: errors)
        }

        return program
    }

    public mutating func parseStatement() throws -> Statement? {
        guard let token = self.currentToken else {
            throw InvalidToken(self.currentToken)
        }

        switch token.type {
        case Token.Kind.let, Token.Kind.var:
            return try parseDeclareStatement()
        case Token.Kind.return:
            return try parseReturnStatement()
        case Token.Kind.identifier:
            if self.nextToken?.type == .assign {
                return try parseAssignStatement()
            } else {
                return try parseExpressionStatement()
            }
        default:
            return try parseExpressionStatement()
        }
    }

    mutating func parseDeclareStatement() throws -> DeclareStatement? {
        guard let token = self.currentToken, token.type == .let || token.type == .var else {
            throw InvalidToken(self.currentToken)
        }

        try expectNext(toBe: .identifier)
        guard let identifierToken = self.currentToken else {
            return nil
        }

        let name = Identifier(token: identifierToken, value: identifierToken.literal)

        try expectNext(toBe: .assign)

        self.readToken()
        guard let expression = try parseExpression(withPrecedence: MonkeyPrecedence.lowest.rawValue) else {
            throw InvalidExpression(self.currentToken)
        }
        try expectNext(toBe: .semicolon)

        return DeclareStatement(token: token, name: name, value: expression)
    }

    mutating func parseAssignStatement() throws -> AssignStatement? {
        guard let identifier = self.currentToken, identifier.type == .identifier else {
            throw InvalidToken(self.currentToken)
        }

        let name = Identifier(token: identifier, value: identifier.literal)
        try expectNext(toBe: .assign)
        self.readToken()
        guard let expression = try parseExpression(withPrecedence: MonkeyPrecedence.lowest.rawValue) else {
            throw InvalidExpression(self.currentToken)
        }
        try expectNext(toBe: .semicolon)

        return AssignStatement(token: identifier, name: name, value: expression)
    }

    mutating func parseReturnStatement() throws -> ReturnStatement? {
        guard let token = self.currentToken, token.type == .return else {
            throw InvalidToken(self.currentToken)
        }

        self.readToken()
        guard let expression = try parseExpression(withPrecedence: MonkeyPrecedence.lowest.rawValue) else {
            throw InvalidExpression(self.currentToken)
        }
        try expectNext(toBe: .semicolon)

        return ReturnStatement(token: token, value: expression)
    }

    mutating func parseExpressionStatement() throws -> ExpressionStatement? {
        guard let token = self.currentToken else {
            throw InvalidToken(self.currentToken)
        }

        guard let expression = try parseExpression(withPrecedence: MonkeyPrecedence.lowest.rawValue) else {
            return nil
        }

        if self.nextToken?.type == .semicolon {
            self.readToken()
        }

        return ExpressionStatement(token: token, expression: expression)
    }

    public mutating func parseExpression(withPrecedence precedence: Int) throws -> Expression? {
        var leftExpression = try self.prefixParser.parse(&self)
        guard leftExpression != nil else {
            throw InvalidExpression(self.currentToken)
        }

        while self.nextToken?.type != .semicolon && precedence < self.nextPrecendece {
            self.readToken()
            guard let currentLhs = leftExpression else {
                throw InvalidExpression(self.currentToken)
            }

            leftExpression = try self.infixParser.parse(&self, lhs: currentLhs)
        }

        return leftExpression
    }
}
