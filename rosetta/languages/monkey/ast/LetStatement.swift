//
//  LetStatement.swift
//  rosetta
//
//  Created by Franklin Cruz on 01-01-21.
//

import Foundation

/// Let statement of Monkey language which should follow this structure:
/// `let <Identifier> = <Expression>;`
struct LetStatement: Statement {
    var token: Token
    var name: Identifier

    var value: Expression

    var literal: String {
        return token.literal
    }
}

/// This `Node` represents a identifier name in Monkey language
/// the valid characters for identifiers are "a-z", "A-Z" and "_" 
struct Identifier: Expression {
    var token: Token
    var value: String

    var literal: String {
        return token.literal
    }
}
