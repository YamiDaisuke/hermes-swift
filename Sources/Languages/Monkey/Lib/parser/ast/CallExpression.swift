//
//  CallExpression.swift
//  Hermes
//
//  Created by Franklin Cruz on 05-01-21.
//

import Foundation
import Hermes

/// Represents a function call expression in the form of
/// `<function expression>(<arguments>)`
/// where function expression can be any expression
/// that produces a function as result. E.G:
/// ```
/// add(a, b)
/// fn (x) { return x * 2 }(2)
/// ```
struct CallExpression: Expression {
    var token: Token // The '(' token
    var function: Expression
    var args: [Expression] = []

    var description: String {
        "\(function)(\(args.map { $0.description }.joined(separator: ", ")))"
    }
}
