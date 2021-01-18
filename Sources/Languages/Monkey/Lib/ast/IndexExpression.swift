//
//  IndexExpression.swift
//  MonkeyLang
//
//  Created by Franklin Cruz on 17-01-21.
//

import Foundation
import Rosetta

/// Holds a reference for an index expression applied on any expression producing an `ArrayLiteral`
/// `<expression>[<expression>]`
struct IndexExpression: Expression {
    var token: Token
    var lhs: Expression
    var index: Expression

    var description: String {
        "(\(lhs.description)[\(index.description)])"
    }
}
