//
//  MonkeyCompilerTests.swift
//  MonkeyTests
//
//  Created by Franklin Cruz on 01-02-21.
//

import XCTest
@testable import Rosetta
@testable import MonkeyLang

class MonkeyCompilerTests: XCTestCase {
    typealias TestCase = (input: String, constants: [Object], instructions: [Instructions])

    func testIntegerArithmetic() throws {
        let tests: [TestCase] = [
            (
                "1 + 1",
                [Integer(value: 1), Integer(value: 2)],
                [Bytecode.make(.constant, operands: [0]), Bytecode.make(.constant, operands: [1])]
            )
        ]

        try runCompilerTests(tests)
    }

    // MARK: Utils

    func runCompilerTests(_ tests: [TestCase], file: StaticString = #file, line: UInt = #line) throws {
        for test in tests {
            let program = try parse(test.input)
            var compiler = MonkeyC()
            try compiler.compile(program)
            let bytecode = compiler.bytecode
            MKAssertInstructions(bytecode.instructions, test.instructions)
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
