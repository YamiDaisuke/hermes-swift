//
//  Utils.swift
//  MonkeyTests
//
//  Created by Franklin Cruz on 19-01-21.
//

import Foundation
@testable import Rosetta
@testable import MonkeyLang

enum Utils {
    static func testEval(input: String, environment: Environment<Object>) throws -> Object? {
        let lexer = MonkeyLexer(withString: input)
        var parser = MonkeyParser(lexer: lexer)

        guard let program = try parser.parseProgram() else {
            return nil
        }
        return try MonkeyEvaluator.eval(program: program, environment: environment)
    }
}
