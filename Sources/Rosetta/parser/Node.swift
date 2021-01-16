//
//  Node.swift
//  rosetta
//
//  Created by Franklin Cruz on 31-12-20.
//

import Foundation

/// All elements in the Parser AST should implement
/// this protocol
public protocol Node: CustomStringConvertible {
    var token: Token { get set }
    var literal: String { get }
}

/// Protocol to indentify `Statement` nodes in the AST
public protocol Statement: Node { }

/// Protocol to indentify `Expression` nodes in the AST
public protocol Expression: Node { }

public extension Node {
    var literal: String {
        return token.literal
    }
}
