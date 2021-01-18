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
    case lessGreater // > or <
    case sum // +
    case product // *
    case prefix // -X, !X
    case call // function(...)
    case index // array[index]
}

public struct MonkeyParser: Parser {
    static let precedences: [Token.Kind: MonkeyPrecedence] = [
        .equals: .equals,
        .notEquals: .equals,
        .lt: .lessGreater,
        .gt: .lessGreater,
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

    public mutating func parseStatement() throws -> Statement? {
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

        self.readToken()
        guard let expression = try parseExpression(withPrecedence: MonkeyPrecedence.lowest.rawValue) else {
            return nil
        }
        try expectNext(toBe: .semicolon)

        return LetStatement(token: token, name: name, value: expression)
    }

    mutating func parseReturnStatement() throws -> ReturnStatement? {
        guard let token = self.currentToken, token.type == .return else {
            return nil
        }

        self.readToken()
        guard let expression = try parseExpression(withPrecedence: MonkeyPrecedence.lowest.rawValue) else {
            return nil
        }
        try expectNext(toBe: .semicolon)

        return ReturnStatement(token: token, value: expression)
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

    public mutating func parseExpression(withPrecedence precedence: Int) throws -> Expression? {
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
}
