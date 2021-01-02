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

    var description: String {
        "\(token.literal) \(name) = \(value);"
    }
}
