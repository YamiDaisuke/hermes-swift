//
//  DeclareStatement.swift
//  MonkeyLang
//
//  Created by Franklin Cruz on 22-01-21.
//

import Foundation
import Hermes

/// Declare either constants or variable values of Monkey language which should follow this structure:
///  Constants:
/// - `let <Identifier> = <Expression>;`
/// Variables:
/// -  `var <Identifier> = <Expression>;`
struct DeclareStatement: Statement {
    var token: Token // var or let
    var name: Identifier

    var value: Expression

    var description: String {
        "\(token.literal) \(name) = \(value);"
    }
}
