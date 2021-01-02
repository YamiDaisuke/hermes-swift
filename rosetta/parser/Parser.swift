//
//  Parser.swift
//  rosetta
//
//  Created by Franklin Cruz on 01-01-21.
//

import Foundation

/// Base protocol for a language `Parser`
protocol Parser {
    /// Will hold helper functions thar will be used to parse expression
    /// components based on how they are used
    typealias PrefixParseFunc = (_ token: Token?) throws -> Expression?
    typealias InfixParseFunc = (_ lhs: Expression, _ token: Token?) throws -> Expression?

    var lexer: Lexer { get set }
    var currentToken: Token? { get set }
    var nextToken: Token? { get set }

    /// Maping of the helper functions to the corresponding `Token.Kind`
    var prefixParseFuncs: [Token.Kind: PrefixParseFunc] { get set }
    var infixParseFuncs: [Token.Kind: InfixParseFunc] { get set }

    mutating func readToken()
    mutating func parseProgram() throws -> Program?
    mutating func parseStatement() throws -> Statement?
}

extension Parser {
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
