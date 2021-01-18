//
//  ExpressionParser.swift
//  rosetta
//
//  Created by Franklin Cruz on 06-01-21.
//

import Foundation
import Rosetta

struct MonkeyPrefixParser: PrefixParser, MonkeyExpressionParser {
    func parse<P>(_ parser: inout P) throws -> Expression? where P: Parser {
        guard let token = parser.currentToken else {
            return nil
        }

        switch token.type {
        case Token.Kind.identifier:
            return try parseIdentifier(&parser)
        case Token.Kind.int:
            return try parseInteger(&parser)
        case Token.Kind.string:
            return try parseString(&parser)
        case Token.Kind.bang, Token.Kind.minus:
            return try parsePrefix(&parser)
        case Token.Kind.true, Token.Kind.false:
            return try parseBoolean(&parser)
        case Token.Kind.lparen:
            return try parseGroupedExpression(&parser)
        case Token.Kind.lbracket:
            return try parseArrayLiteral(&parser)
        case Token.Kind.if:
            return try parseIfExpression(&parser)
        case Token.Kind.function:
            return try parseFunctionLiteral(&parser)
        default:
            throw MissingPrefixFunc(token: token)
        }
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

    func parseString<P>(_ parser: inout P) throws -> Expression? where P: Parser {
        guard let token = parser.currentToken, token.type == .string else {
            return nil
        }

        return StringLiteral(token: token)
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

    func parseArrayLiteral<P>(_ parser: inout P) throws -> Expression? where P: Parser {
        guard let token = parser.currentToken, token.type == .lbracket else {
            return nil
        }

        let elements = try self.parseExpressionList(withEndDelimiter: .rbracket, parser: &parser)
        return ArrayLiteral(token: token, elements: elements)
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

        guard let consequence = try self.parseBlockStatement(parser: &parser) else {
            return nil
        }

        var alternative: BlockStatement?
        if parser.nextToken?.type == .else {
            parser.readToken()

            try parser.expectNext(toBe: .lbrace)
            alternative = try parseBlockStatement(parser: &parser)
        }

        return IfExpression(
            token: token,
            condition: condition,
            consequence: consequence,
            alternative: alternative
        )
    }

    func parseFunctionLiteral<P>(_ parser: inout P) throws -> Expression? where P: Parser {
        guard let token = parser.currentToken, token.type == .function else {
            return nil
        }

        try parser.expectNext(toBe: .lparen)
        let params = try self.parseFunctionParams(parser: &parser)

        try parser.expectNext(toBe: .lbrace)

        guard let body = try self.parseBlockStatement(parser: &parser) else {
            return nil
        }

        return FunctionLiteral(token: token, params: params, body: body)
    }

    func parseFunctionParams<P>(parser: inout P) throws -> [Identifier] where P: Parser {
        var identifiers: [Identifier] = []

        guard parser.nextToken?.type != .rparen else {
            parser.readToken()
            return identifiers
        }

        parser.readToken()

        if let token = parser.currentToken, token.type == .identifier {
            identifiers.append(Identifier(token: token, value: token.literal))
        }

        while parser.nextToken?.type == .comma {
            parser.readToken()
            parser.readToken()
            if let token = parser.currentToken, token.type == .identifier {
                identifiers.append(Identifier(token: token, value: token.literal))
            }
        }

        try parser.expectNext(toBe: .rparen)

        return identifiers
    }

    func parseBlockStatement<P>(parser: inout P) throws -> BlockStatement? where P: Parser {
        guard let token = parser.currentToken, token.type == .lbrace else {
            return nil
        }

        var statements: [Statement] = []
        parser.readToken()
        while parser.currentToken?.type != .rbrace && parser.currentToken?.type != .eof {
            if let statement = try parser.parseStatement() {
                statements.append(statement)
            }
            parser.readToken()
        }

        return BlockStatement(token: token, statements: statements)
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
