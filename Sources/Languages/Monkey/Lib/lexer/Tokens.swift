//
//  Tokens.swift
//  rossetta
//
//  Created by Franklin Cruz on 28-12-20.
//

import Foundation
import Rosetta

// Identifiers and literals
public extension Token.Kind {
    static let comment = Token.Kind("comment")
    static let identifier = Token.Kind("identifier")
    static let int = Token.Kind("int")
    static let string = Token.Kind("string")

    static var literals: Set<Token.Kind> {
        [.int, .string]
    }
}

// Operators
public extension Token.Kind {
    static let assign = Token.Kind("=")
    static let equals = Token.Kind("==")
    static let plus = Token.Kind("+")
    static let minus = Token.Kind("-")
    static let bang = Token.Kind("!")
    static let notEquals = Token.Kind("!=")
    static let asterisk = Token.Kind("*")
    static let slash = Token.Kind("/")
    static let lt = Token.Kind("<")
    static let lte = Token.Kind("<=")
    static let gt = Token.Kind(">")
    static let gte = Token.Kind(">=")

    static var operators: Set<Token.Kind> {
        [
            .assign,
            .equals,
            .plus,
            .minus,
            .bang,
            .notEquals,
            .asterisk,
            .slash,
            .lt,
            .lte,
            .gt,
            .gte
        ]
    }
}

// Delimiters
public extension Token.Kind {
    static let comma = Token.Kind(",")
    static let semicolon = Token.Kind(";")
    static let colon = Token.Kind(":")

    static let lparen = Token.Kind("(")
    static let rparen = Token.Kind(")")
    static let lbrace = Token.Kind("{")
    static let rbrace = Token.Kind("}")
    static let lbracket = Token.Kind("[")
    static let rbracket = Token.Kind("]")

    static var delimiters: Set<Token.Kind> {
        [
            .comma,
            .semicolon,
            .colon,
            .lparen,
            .rparen,
            .lbrace,
            .rbrace,
            .lbracket,
            .rbracket
        ]
    }
}

// Keywords
public extension Token.Kind {
    static let function = Token.Kind("fn")
    static let `let` = Token.Kind("let")
    static let `var` = Token.Kind("var")
    static let `true` = Token.Kind("true")
    static let `false` = Token.Kind("false")
    static let `if` = Token.Kind("if")
    static let `else` = Token.Kind("else")
    static let `return` = Token.Kind("return")

    static var keywords: Set<Token.Kind> {
        [.function, .let, .var, .true, .false, .if, .else, .return]
    }
}
