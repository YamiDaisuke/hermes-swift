//
//  BlockStatement.swift
//  rosetta
//
//  Created by Franklin Cruz on 04-01-21.
//

import Foundation
import Rosetta

/// Represent expressions in the form of:
/// `{ <statement> }`
/// where we can have any number of statements
struct BlockStatement: Statement {
    var token: Token
    var statements: [Statement] = []

    var description: String {
        var output = "{\n"
        for stmt in statements {
            output += "\t"
            output += stmt.description
            output += ";\n"
        }
        output += "}\n"
        return output
    }
}
