//
//  CommentStatement.swift
//  MonkeyLang
//
//  Created by Franklin Cruz on 16-02-21.
//

import Foundation
import Rosetta

/// Comment text for documentation
struct CommentStatement: Statement {
    var token: Token
    var text: String

    var description: String {
        "/* \(text) */\n"
    }
}
