//
//  BooleanLiteral.swift
//  Hermes
//
//  Created by Franklin Cruz on 03-01-21.
//

import Foundation
import Hermes

/// This `Node` represents an boolean literal in Monkey language
struct BooleanLiteral: Expression {
    var token: Token
    var value: Bool

    init(token: Token) throws {
        self.token = token
        self.value = token.type != .false && token.type == .true
    }

    var description: String {
        value.description
    }
}
