//
//  HashLiteral.swift
//  MonkeyLang
//
//  Created by Franklin Cruz on 20-01-21.
//

import Foundation
import Hermes

struct HashLiteral: Expression {
    typealias Pair = (key: Expression, value: Expression)

    var token: Token // the "{" token
    var pairs: [Pair]

    var description: String {
        "{\(pairs.map { "\"\($0.key)\" : \"\($0.value)\"" }.joined(separator: ", "))}"
    }
}
