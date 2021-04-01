//
//  Identifier.swift
//  rosetta
//
//  Created by Franklin Cruz on 02-01-21.
//

import Foundation
import Hermes

/// This `Node` represents a identifier name in Monkey language
/// the valid characters for identifiers are "a-z", "A-Z" and "_"
struct Identifier: Expression {
    var token: Token
    var value: String

    var description: String {
        value
    }
}
