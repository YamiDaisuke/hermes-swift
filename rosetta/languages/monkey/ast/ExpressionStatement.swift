//
//  ExpressionStatement.swift
//  rosetta
//
//  Created by Franklin Cruz on 02-01-21.
//

import Foundation

struct ExpressionStatement: Statement {
    var token: Token
    var expression: Expression

    var description: String {
        expression.description
    }
}
