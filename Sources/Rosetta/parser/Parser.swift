//
//  Parser.swift
//  rosetta
//
//  Created by Franklin Cruz on 01-01-21.
//

import Foundation

/// Parse expression construct with operator prefixing
/// <prefix operator><expression>
public protocol PrefixParser {
    func parse<P>(_ parser: inout P) throws -> Expression? where P: Parser
}

/// Parse expression construct with operator infixing
/// <expression> <infix operator> <expression>
public protocol InfixParser {
    func parse<P>(_ parser: inout P, lhs: Expression) throws -> Expression? where P: Parser
}

/// Base protocol for a language `Parser`
public protocol Parser {
    var lexer: Lexer { get set }
    var currentToken: Token? { get set }
    var currentPrecendece: Int { get }
    var nextToken: Token? { get set }
    var nextPrecendece: Int { get }

    /// Will hold helper functions thar will be used to parse expression
    /// components based on how they are used
    var prefixParser: PrefixParser { get set }
    var infixParser: InfixParser { get set }

    mutating func readToken()
    mutating func parseProgram() throws -> Program?
    mutating func parseStatement() throws -> Statement?
    mutating func parseExpression(withPrecedence precedence: Int) throws -> Expression?
}

public extension Parser {
    /// Reads the next `Token` from the associated `Lexer`
    mutating func readToken() {
        self.currentToken = self.nextToken
        self.nextToken = self.lexer.nextToken()
    }

    /// Checks if the next `Token` in the `Lexer` is of a type, if it is
    /// reads and move the pointers to that `Token` if not, throw an error
    /// - Parameter type: Which type should the next `Token` be
    /// - Throws: `MissingExpected` if the `Token` is not the right type
    mutating func expectNext(toBe type: Token.Kind) throws {
        if self.nextToken?.type == type {
            self.readToken()
            return
        }

        throw MissingExpected(type: type, line: self.nextToken?.line, column: self.nextToken?.column)
    }
}
