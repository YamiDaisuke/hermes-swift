//
//  MonkeyCompilerTests.swift
//  MonkeyTests
//
//  Created by Franklin Cruz on 01-02-21.
//

import XCTest
@testable import Hermes
@testable import MonkeyLang

// swiftlint:disable type_body_length
class MonkeyCompilerTests: XCTestCase, CompilerTestsHelpers {
    func testFloats() throws {
        let tests: [CompilerTestCase] = [
            (
                "1.0; 2.0;",
                [MFloat(1), MFloat(2)],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.pop),
                    Bytecode.make(.constant, 1),
                    Bytecode.make(.pop)
                ]
            )
        ]

        try runCompilerTests(tests)
    }

    func testIntegerArithmetic() throws {
        let tests: [CompilerTestCase] = [
            (
                "1; 2;",
                [Integer(1), Integer(2)],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.pop),
                    Bytecode.make(.constant, 1),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "1 + 2",
                [Integer(1), Integer(2)],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.constant, 1),
                    Bytecode.make(.add),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "1 - 2",
                [Integer(1), Integer(2)],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.constant, 1),
                    Bytecode.make(.sub),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "1 * 2",
                [Integer(1), Integer(2)],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.constant, 1),
                    Bytecode.make(.mul),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "1 / 2",
                [Integer(1), Integer(2)],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.constant, 1),
                    Bytecode.make(.div),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "-1",
                [Integer(1)],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.minus),
                    Bytecode.make(.pop)
                ]
            )
        ]

        try runCompilerTests(tests)
    }

    func testBooleanExpressions() throws {
        let tests: [CompilerTestCase] = [
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
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.constant, 1),
                    Bytecode.make(.gt),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "1 < 2",
                [Integer(2), Integer(1)],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.constant, 1),
                    Bytecode.make(.gt),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "1 >= 2",
                [Integer(1), Integer(2)],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.constant, 1),
                    Bytecode.make(.gte),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "1 <= 2",
                [Integer(2), Integer(1)],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.constant, 1),
                    Bytecode.make(.gte),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "1 == 2",
                [Integer(1), Integer(2)],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.constant, 1),
                    Bytecode.make(.equal),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "1 != 2",
                [Integer(1), Integer(2)],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.constant, 1),
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

    func testStringExpressions() throws {
        let tests: [CompilerTestCase] = [
            (
                "\"monkey\"",
                [MString("monkey")],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "\"mon\" + \"key\"",
                [MString("mon"), MString("key")],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.constant, 1),
                    Bytecode.make(.add),
                    Bytecode.make(.pop)
                ]
            )
        ]

        try runCompilerTests(tests)
    }

    func testConditionals() throws {
        let tests: [CompilerTestCase] = [
            (
                "if (true) { 10 }; 3333;",
                [Integer(10), Integer(3333)],
                [
                    // 0000
                    Bytecode.make(.true),
                    // 0001
                    Bytecode.make(.jumpf, 10),
                    // 0004
                    Bytecode.make(.constant, 0),
                    // 0007
                    Bytecode.make(.jump, 11),
                    // 0010
                    Bytecode.make(.null),
                    // 0011
                    Bytecode.make(.pop),
                    // 0012
                    Bytecode.make(.constant, 1),
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
                    Bytecode.make(.jumpf, 10),
                    // 0004
                    Bytecode.make(.constant, 0),
                    // 0007
                    Bytecode.make(.jump, 13),
                    // 0010
                    Bytecode.make(.constant, 1),
                    // 0013
                    Bytecode.make(.pop),
                    // 0014
                    Bytecode.make(.constant, 2),
                    // 0017
                    Bytecode.make(.pop)
                ]
            )
        ]

        try runCompilerTests(tests)
    }

    func testGlobalLetStatements() throws {
        let tests: [CompilerTestCase] = [
            (
                "let one = 1; let two = 2;",
                [Integer(1), Integer(2)],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.setGlobal, 0),
                    Bytecode.make(.constant, 1),
                    Bytecode.make(.setGlobal, 1)
                ]
            ),
            (
                "let one = 1; one;",
                [Integer(1)],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.setGlobal, 0),
                    Bytecode.make(.getGlobal, 0),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "let one = 1; let two = one; two",
                [Integer(1)],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.setGlobal, 0),
                    Bytecode.make(.getGlobal, 0),
                    Bytecode.make(.setGlobal, 1),
                    Bytecode.make(.getGlobal, 1),
                    Bytecode.make(.pop)
                ]
            ),
            // This should fail because we are trying to assing a let value
            (
                "let fail = 1; fail = 2;",
                [Integer(1)],
                []
            ),
            // This should fail because we are trying to create a new global with the same name
            (
                "let fail = 1; let fail = 2;",
                [Integer(1)],
                []
            )
        ]

        for test in tests {
            do {
                try runCompilerTest(test)
            } catch let error as AssignConstantError {
                XCTAssertTrue(error.description.starts(with: "Cannot assign to value: \"fail\" is a constant"))
            } catch let error as RedeclarationError {
                XCTAssertTrue(error.description.starts(with: "Cannot redeclare: \"fail\" it already exists"))
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }

    func testGlobalVarStatements() throws {
        let tests: [CompilerTestCase] = [
            (
                "var one = 1; var two = 2;",
                [Integer(1), Integer(2)],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.setGlobal, 0),
                    Bytecode.make(.constant, 1),
                    Bytecode.make(.setGlobal, 1)
                ]
            ),
            (
                "var one = 1; one;",
                [Integer(1)],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.setGlobal, 0),
                    Bytecode.make(.getGlobal, 0),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "var one = 1; var two = one; two",
                [Integer(1)],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.setGlobal, 0),
                    Bytecode.make(.getGlobal, 0),
                    Bytecode.make(.setGlobal, 1),
                    Bytecode.make(.getGlobal, 1),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "var one = 1; one = 2; one",
                [Integer(1), Integer(2)],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.setGlobal, 0),
                    Bytecode.make(.constant, 1),
                    Bytecode.make(.assignGlobal, 0),
                    Bytecode.make(.getGlobal, 0),
                    Bytecode.make(.pop)
                ]
            )
        ]

        try runCompilerTests(tests)
    }
}
