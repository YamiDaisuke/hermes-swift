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
                "1; 2;",
                [Integer(1), Integer(2)],
                [
                    Bytecode.make(.constant, operands: [0]),
                    Bytecode.make(.pop),
                    Bytecode.make(.constant, operands: [1]),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "1 + 2",
                [Integer(1), Integer(2)],
                [
                    Bytecode.make(.constant, operands: [0]),
                    Bytecode.make(.constant, operands: [1]),
                    Bytecode.make(.add),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "1 - 2",
                [Integer(1), Integer(2)],
                [
                    Bytecode.make(.constant, operands: [0]),
                    Bytecode.make(.constant, operands: [1]),
                    Bytecode.make(.sub),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "1 * 2",
                [Integer(1), Integer(2)],
                [
                    Bytecode.make(.constant, operands: [0]),
                    Bytecode.make(.constant, operands: [1]),
                    Bytecode.make(.mul),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "1 / 2",
                [Integer(1), Integer(2)],
                [
                    Bytecode.make(.constant, operands: [0]),
                    Bytecode.make(.constant, operands: [1]),
                    Bytecode.make(.div),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "-1",
                [Integer(1)],
                [
                    Bytecode.make(.constant, operands: [0]),
                    Bytecode.make(.minus),
                    Bytecode.make(.pop)
                ]
            )
        ]

        try runCompilerTests(tests)
    }

    func testBooleanExpressions() throws {
        let tests: [TestCase] = [
            (
                "true",
                [],
                [
                    Bytecode.make(.true),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "false",
                [],
                [
                    Bytecode.make(.false),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "1 > 2",
                [Integer(1), Integer(2)],
                [
                    Bytecode.make(.constant, operands: [0]),
                    Bytecode.make(.constant, operands: [1]),
                    Bytecode.make(.gt),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "1 < 2",
                [Integer(2), Integer(1)],
                [
                    Bytecode.make(.constant, operands: [0]),
                    Bytecode.make(.constant, operands: [1]),
                    Bytecode.make(.gt),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "1 >= 2",
                [Integer(1), Integer(2)],
                [
                    Bytecode.make(.constant, operands: [0]),
                    Bytecode.make(.constant, operands: [1]),
                    Bytecode.make(.gte),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "1 <= 2",
                [Integer(2), Integer(1)],
                [
                    Bytecode.make(.constant, operands: [0]),
                    Bytecode.make(.constant, operands: [1]),
                    Bytecode.make(.gte),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "1 == 2",
                [Integer(1), Integer(2)],
                [
                    Bytecode.make(.constant, operands: [0]),
                    Bytecode.make(.constant, operands: [1]),
                    Bytecode.make(.equal),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "1 != 2",
                [Integer(1), Integer(2)],
                [
                    Bytecode.make(.constant, operands: [0]),
                    Bytecode.make(.constant, operands: [1]),
                    Bytecode.make(.notEqual),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "true == false",
                [],
                [
                    Bytecode.make(.true),
                    Bytecode.make(.false),
                    Bytecode.make(.equal),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "true != false",
                [],
                [
                    Bytecode.make(.true),
                    Bytecode.make(.false),
                    Bytecode.make(.notEqual),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "!true",
                [],
                [
                    Bytecode.make(.true),
                    Bytecode.make(.bang),
                    Bytecode.make(.pop)
                ]
            )
        ]

        try runCompilerTests(tests)
    }

    func testConditionals() throws {
        let tests: [TestCase] = [
            (
                "if (true) { 10 }; 3333;",
                [Integer(10), Integer(3333)],
                [
                    // 0000
                    Bytecode.make(.true),
                    // 0001
                    Bytecode.make(.jumpf, operands: [10]),
                    // 0004
                    Bytecode.make(.constant, operands: [0]),
                    // 0007
                    Bytecode.make(.jump, operands: [11]),
                    // 0010
                    Bytecode.make(.null),
                    // 0011
                    Bytecode.make(.pop),
                    // 0012
                    Bytecode.make(.constant, operands: [1]),
                    // 0015
                    Bytecode.make(.pop)
                ]
            ),
            (
                "if (true) { 10 } else { 20 }; 3333;",
                [Integer(10), Integer(20), Integer(3333)],
                [
                    // 0000
                    Bytecode.make(.true),
                    // 0001
                    Bytecode.make(.jumpf, operands: [10]),
                    // 0004
                    Bytecode.make(.constant, operands: [0]),
                    // 0007
                    Bytecode.make(.jump, operands: [13]),
                    // 0010
                    Bytecode.make(.constant, operands: [1]),
                    // 0013
                    Bytecode.make(.pop),
                    // 0014
                    Bytecode.make(.constant, operands: [2]),
                    // 0017
                    Bytecode.make(.pop)
                ]
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
