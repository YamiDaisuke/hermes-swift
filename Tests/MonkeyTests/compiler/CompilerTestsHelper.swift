//
//  CompilerTestsHelper.swift
//  MonkeyTests
//
//  Created by Franklin Cruz on 11-03-21.
//

import XCTest
@testable import Rosetta
@testable import MonkeyLang

protocol CompilerTestsHelpers {
}

typealias CompilerTestCase = (input: String, constants: [Object], instructions: [Instructions])

extension CompilerTestsHelpers {
    func runCompilerTests(_ tests: [CompilerTestCase], file: StaticString = #file, line: UInt = #line) throws {
        for test in tests {
            let program = try parse(test.input)
            var compiler = MonkeyC()
            try compiler.compile(program)
            let bytecode = compiler.bytecode
            MKAssertInstructions(bytecode.instructions, test.instructions)
            MKAssertConstants(bytecode.constants, test.constants)
        }
    }

    func parse(_ input: String, file: StaticString = #file, line: UInt = #line) throws -> Program {
        let lexer = MonkeyLexer(withString: input)
        var parser = MonkeyParser(lexer: lexer)
        guard let program = try parser.parseProgram() else {
            XCTFail("Resulting program is nil")
            return Program(statements: [])
        }

        return program
    }
}
