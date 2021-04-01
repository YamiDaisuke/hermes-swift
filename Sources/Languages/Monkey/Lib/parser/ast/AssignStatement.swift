//
//  AssignStatement.swift
//  MonkeyLang
//
//  Created by Franklin Cruz on 22-01-21.
//

import Foundation
import Hermes

/// Assign statement of Monkey language which should follow this structure:
/// `<Identifier> = <Expression>;`
struct AssignStatement: Statement {
    var token: Token
    var name: Identifier

    var value: Expression

    var description: String {
        "\(name) = \(value);"
    }
}
