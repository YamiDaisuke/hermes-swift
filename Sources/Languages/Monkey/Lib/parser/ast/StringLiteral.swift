//
//  StringLiteral.swift
//  MonkeyLang
//
//  Created by Franklin Cruz on 16-01-21.
//

import Foundation
import Hermes

/// This `Node` represents an string literal in Monkey language
struct StringLiteral: Expression {
    var token: Token
    var value: String

    init(token: Token) {
        self.token = token
        self.value = token.literal
    }

    var description: String {
        value.description
    }
}
