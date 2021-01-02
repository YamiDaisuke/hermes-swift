//
//  ReturnStatement.swift
//  rosetta
//
//  Created by Franklin Cruz on 02-01-21.
//

import Foundation

struct ReturnStatement: Statement {
    var token: Token
    var value: Expression

    var literal: String {
        return token.literal
    }
}
