//
//  Token.swift
//  rossetta
//
//  Created by Franklin Cruz on 27-12-20.
//

import Foundation


/// Represents any token within a code block
struct Token {
    typealias Kind = String
    
    let type: Token.Kind
    let literal: String
    
    let file: String? = nil
    let line: Int? = nil
    let column: Int? = nil
}

extension Token: Equatable {
    static func ==(lhs: Token, rhs: Token) -> Bool {
        return lhs.type == rhs.type && lhs.literal == rhs.literal
    }
}

// Special
extension Token.Kind {
    static let ilegal = Token.Kind("ilegal")
    static let eof = Token.Kind("eof")
}
