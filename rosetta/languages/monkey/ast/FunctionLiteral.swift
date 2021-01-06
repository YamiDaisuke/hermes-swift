//
//  FunctionLiteral.swift
//  rosetta
//
//  Created by Franklin Cruz on 05-01-21.
//

import Foundation

struct FuctionLiteral: Expression {
    var token: Token
    var params: [Identifier] = []
    var body: BlockStatement

    var description: String {
        "fn(\(params.map({$0.description}).joined(separator: ", "))\n\(self.body)"
    }
}
