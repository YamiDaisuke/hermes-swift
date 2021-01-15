//
//  ReturnStatement.swift
//  rosetta
//
//  Created by Franklin Cruz on 02-01-21.
//

import Foundation
import Rosetta

struct ReturnStatement: Statement {
    var token: Token
    var value: Expression

    var description: String {
        "\(token.literal) \(value);"
    }
}
