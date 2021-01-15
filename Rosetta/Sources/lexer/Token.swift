//
//  Token.swift
//  rossetta
//
//  Created by Franklin Cruz on 27-12-20.
//

import Foundation

/// Represents any token within a code block
public struct Token {
    public typealias Kind = String

    public let type: Token.Kind
    public let literal: String

    public var file: String?
    public var line: Int?
    public var column: Int?

    public init(type: Token.Kind, literal: String, file: String? = nil, line: Int? = nil, column: Int? = nil) {
        self.type = type
        self.literal = literal
        self.file = file
        self.line = line
        self.column = column
    }
}

extension Token: Equatable {
    public static func == (lhs: Token, rhs: Token) -> Bool {
        return lhs.type == rhs.type && lhs.literal == rhs.literal
    }
}

// Special
public extension Token.Kind {
    static let ilegal = Token.Kind("ilegal")
    static let eof = Token.Kind("eof")
}
