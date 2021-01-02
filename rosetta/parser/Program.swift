//
//  Program.swift
//  rosetta
//
//  Created by Franklin Cruz on 01-01-21.
//

import Foundation

/// Root `Node` for any Monkey Language script
struct Program: Node {
    var statements: [Statement]
    var literal: String {
        if let first = statements.first {
            return first.literal
        }
        return ""
    }
}
