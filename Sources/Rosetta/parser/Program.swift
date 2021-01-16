//
//  Program.swift
//  rosetta
//
//  Created by Franklin Cruz on 01-01-21.
//

import Foundation

/// Root for any Monkey Language script
public struct Program: CustomStringConvertible {
    public var statements: [Statement]

    public init(statements: [Statement]) {
        self.statements = statements
    }

    public var literal: String {
        if let first = statements.first {
            return first.literal
        }
        return ""
    }

    public var description: String {
        var output = ""
        for statement in self.statements {
            output += "\(statement)\n"
        }
        return output
    }
}
