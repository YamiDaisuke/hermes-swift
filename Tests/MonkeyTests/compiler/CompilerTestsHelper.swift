//
//  CompilerTestsHelper.swift
//  MonkeyTests
//
//  Created by Franklin Cruz on 11-03-21.
//

import XCTest
@testable import Hermes
@testable import MonkeyLang

protocol CompilerTestsHelpers {
}

typealias CompilerTestCase = (input: String, constants: [Object], instructions: [Instructions])

extension CompilerTestsHelpers {
    func runCompilerTests(_ tests: [CompilerTestCase], file: StaticString = #file, line: UInt = #line) throws {
        for test in tests {
            try runCompilerTest(test)
        }
    }

    func runCompilerTest(_ test: CompilerTestCase, file: StaticString = #file, line: UInt = #line) throws {
        let bytecode = try compile(test.input)
        MKAssertInstructions(bytecode.instructions, test.instructions)
        MKAssertConstants(bytecode.constants, test.constants)
    }

    func compile(_ input: String, file: StaticString = #file, line: UInt = #line) throws -> BytecodeProgram {
        let program = try parse(input)
        var compiler = MonkeyC()
        try compiler.compile(program)
        let bytecode = compiler.bytecode
        return bytecode
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
