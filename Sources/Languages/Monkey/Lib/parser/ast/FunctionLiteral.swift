//
//  FunctionLiteral.swift
//  rosetta
//
//  Created by Franklin Cruz on 05-01-21.
//

import Foundation
import Rosetta

struct FunctionLiteral: Expression {
    var token: Token
    var name: String?
    var params: [Identifier] = []
    var body: BlockStatement

    var description: String {
        let output = "fn(\(params.map { $0.description }.joined(separator: ", "))\n\(self.body)"
        if let name = name {
            return "\(name) \(output)"
        } else {
            return output
        }
    }
}
