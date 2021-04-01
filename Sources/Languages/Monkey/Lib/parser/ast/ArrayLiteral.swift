//
//  ArrayLiteral.swift
//  MonkeyLang
//
//  Created by Franklin Cruz on 17-01-21.
//

import Foundation
import Hermes

/// Holds a reference for an array literal, expressed in the form:
/// `[<expression>, <epxression>,...,<expression>]`
struct ArrayLiteral: Expression {
    var token: Token // The '[' token
    /// The expressions stored in this array
    var elements: [Expression]

    var description: String {
        "[\(elements.map { $0.description }.joined(separator: ", "))]"
    }
}
