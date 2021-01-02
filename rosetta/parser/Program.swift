//
//  Program.swift
//  rosetta
//
//  Created by Franklin Cruz on 01-01-21.
//

import Foundation

/// Root for any Monkey Language script
struct Program {
    var statements: [Statement]
    var literal: String {
        if let first = statements.first {
            return first.literal
        }
        return ""
    }
}
