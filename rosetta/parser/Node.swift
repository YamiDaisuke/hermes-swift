//
//  Node.swift
//  rosetta
//
//  Created by Franklin Cruz on 31-12-20.
//

import Foundation

/// All elements in the Parser AST should implement
/// this protocol
protocol Node {
    var token: Token { get set }
    var literal: String { get }
}

/// Protocol to indentify `Statement` nodes in the AST
protocol Statement: Node { }

/// Protocol to indentify `Expression` nodes in the AST
protocol Expression: Node { }

extension Node {
    var literal: String {
        return token.literal
    }
}
