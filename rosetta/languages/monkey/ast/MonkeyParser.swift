//
//  MonkeyParser.swift
//  rosetta
//
//  Created by Franklin Cruz on 01-01-21.
//

import Foundation

enum Precedence: Int {
    case lowest
    case equals // ==
    case lessGreater // > or <
    case sum // +
    case product // *
    case prefix // -X, !X
    case call // function(...)
}

struct MonkeyParser: Parser {
    var lexer: Lexer

    var currentToken: Token?
    var nextToken: Token?

    var prefixParseFuncs: [Token.Kind: PrefixParseFunc] = [:]
    var infixParseFuncs: [Token.Kind: InfixParseFunc] = [:]

    init(lexer: Lexer) {
        self.lexer = lexer

        // Register parsing functions
        self.prefixParseFuncs[.identifier] = { token in
            guard let token = token, token.type == .identifier else {
                return nil
            }

            return Identifier(token: token, value: token.literal)
        }

        self.prefixParseFuncs[.int] = { token in
            guard let token = token, token.type == .int else {
                return nil
            }

            return try IntegerLiteral(token: token)
        }
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

        guard let expression = try parseExpression(withPrecedence: .lowest) else {
            return nil
        }

        if self.nextToken?.type == .semicolon {
            self.readToken()
        }

        return ExpressionStatement(token: token, expression: expression)
    }

    mutating func parseExpression(withPrecedence precedence: Precedence) throws -> Expression? {
        guard let token = self.currentToken else {
            return nil
        }

        guard let prefix = self.prefixParseFuncs[token.type] else {
            return nil
        }

        let leftExpression = try prefix(token)
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
