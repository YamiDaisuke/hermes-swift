//
//  ArrayLiteral.swift
//  MonkeyLang
//
//  Created by Franklin Cruz on 17-01-21.
//

import Foundation
import Rosetta

struct ArrayLiteral: Expression {
    var token: Token // The '[' token
    var elements: [Expression]

    var description: String {
        "[\(elements.map({$0.description}).joined(separator: ", "))]"
    }
}
