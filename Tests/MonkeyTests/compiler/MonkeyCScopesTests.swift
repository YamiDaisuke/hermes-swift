//
//  MonkeyCScopesTests.swift
//  MonkeyTests
//
//  Created by Franklin Cruz on 11-03-21.
//

import XCTest
@testable import Hermes
@testable import MonkeyLang


// This tests are quite long so we can't met the body length restriction
// swiftlint:disable function_body_length
class MonkeyCScopesTests: XCTestCase, CompilerTestsHelpers {
    func testLetStatementsScopes() throws {
        let tests: [CompilerTestCase] = [
            (
                "let num = 55; \n fn() { num }",
                [
                    Integer(55),
                    CompiledFunction(
                        instructions: Array([
                            Bytecode.make(.getGlobal, 0),
                            Bytecode.make(.returnVal)
                        ].joined()),
                        localsCount: 0
                    )
                ],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.setGlobal, 0),
                    Bytecode.make(.closure, 1, 0),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "fn () { let num = 55; num }",
                [
                    Integer(55),
                    CompiledFunction(
                        instructions: Array([
                            Bytecode.make(.constant, 0),
                            Bytecode.make(.setLocal, 0),
                            Bytecode.make(.getLocal, 0),
                            Bytecode.make(.returnVal)
                        ].joined()),
                        localsCount: 0
                    )
                ],
                [
                    Bytecode.make(.closure, 1, 0),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "fn () { let a = 55; let b = 77; a + b }",
                [
                    Integer(55),
                    Integer(77),
                    CompiledFunction(
                        instructions: Array([
                            Bytecode.make(.constant, 0),
                            Bytecode.make(.setLocal, 0),
                            Bytecode.make(.constant, 1),
                            Bytecode.make(.setLocal, 1),
                            Bytecode.make(.getLocal, 0),
                            Bytecode.make(.getLocal, 1),
                            Bytecode.make(.add),
                            Bytecode.make(.returnVal)
                        ].joined()),
                        localsCount: 2
                    )
                ],
                [
                    Bytecode.make(.closure, 2, 0),
                    Bytecode.make(.pop)
                ]
            )
        ]

        try runCompilerTests(tests)
    }

    func testVarStatementsScopes() throws {
        let tests: [CompilerTestCase] = [
            (
                "var num = 55; \n fn() { num }",
                [
                    Integer(55),
                    CompiledFunction(
                        instructions: Array([
                            Bytecode.make(.getGlobal, 0),
                            Bytecode.make(.returnVal)
                        ].joined()),
                        localsCount: 0
                    )
                ],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.setGlobal, 0),
                    Bytecode.make(.closure, 1, 0),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "fn () { var num = 55; num }",
                [
                    Integer(55),
                    CompiledFunction(
                        instructions: Array([
                            Bytecode.make(.constant, 0),
                            Bytecode.make(.setLocal, 0),
                            Bytecode.make(.getLocal, 0),
                            Bytecode.make(.returnVal)
                        ].joined()),
                        localsCount: 1
                    )
                ],
                [
                    Bytecode.make(.closure, 1, 0),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "fn () { var a = 55; var b = 77; a + b }",
                [
                    Integer(55),
                    Integer(77),
                    CompiledFunction(
                        instructions: Array([
                            Bytecode.make(.constant, 0),
                            Bytecode.make(.setLocal, 0),
                            Bytecode.make(.constant, 1),
                            Bytecode.make(.setLocal, 1),
                            Bytecode.make(.getLocal, 0),
                            Bytecode.make(.getLocal, 1),
                            Bytecode.make(.add),
                            Bytecode.make(.returnVal)
                        ].joined()),
                        localsCount: 2
                    )
                ],
                [
                    Bytecode.make(.closure, 2, 0),
                    Bytecode.make(.pop)
                ]
            )
        ]

        try runCompilerTests(tests)
    }

    func testRedeclarionScopes() throws {
        let tests: [CompilerTestCase] = [
            (
                "let num = 55; \n fn() { let num = 60; num; }",
                [
                    Integer(55),
                    Integer(60),
                    CompiledFunction(
                        instructions: Array([
                            Bytecode.make(.constant, 1),
                            Bytecode.make(.setLocal, 0),
                            Bytecode.make(.getLocal, 0),
                            Bytecode.make(.returnVal)
                        ].joined()),
                        localsCount: 1
                    )
                ],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.setGlobal, 0),
                    Bytecode.make(.closure, 2, 0),
                    Bytecode.make(.pop)
                ]
            )
        ]

        try runCompilerTests(tests)
    }

    func testAssigmentScopes() throws {
        let tests: [CompilerTestCase] = [
            (
                "var num = 55; \n fn() { num = 60; num; }",
                [
                    Integer(55),
                    Integer(60),
                    CompiledFunction(
                        instructions: Array([
                            Bytecode.make(.constant, 1),
                            Bytecode.make(.assignGlobal, 0),
                            Bytecode.make(.getGlobal, 0),
                            Bytecode.make(.returnVal)
                        ].joined()),
                        localsCount: 0
                    )
                ],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.setGlobal, 0),
                    Bytecode.make(.closure, 2, 0),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "var num = 55; \n fn() { var num = 10; num = 60; num; }",
                [
                    Integer(55),
                    Integer(10),
                    Integer(60),
                    CompiledFunction(
                        instructions: Array([
                            Bytecode.make(.constant, 1),
                            Bytecode.make(.setLocal, 0),
                            Bytecode.make(.constant, 2),
                            Bytecode.make(.assignLocal, 0),
                            Bytecode.make(.getLocal, 0),
                            Bytecode.make(.returnVal)
                        ].joined()),
                        localsCount: 1
                    )
                ],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.setGlobal, 0),
                    Bytecode.make(.closure, 3, 0),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "let num = 55; \n fn() { var num = 10; num = 60; num; }",
                [
                    Integer(55),
                    Integer(10),
                    Integer(60),
                    CompiledFunction(
                        instructions: Array([
                            Bytecode.make(.constant, 1),
                            Bytecode.make(.setLocal, 0),
                            Bytecode.make(.constant, 2),
                            Bytecode.make(.assignLocal, 0),
                            Bytecode.make(.getLocal, 0),
                            Bytecode.make(.returnVal)
                        ].joined()),
                        localsCount: 1
                    )
                ],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.setGlobal, 0),
                    Bytecode.make(.closure, 3, 0),
                    Bytecode.make(.pop)
                ]
            ),
            (
                // This one will throw an error
                "let const = 55; \n fn() { const = 60; const; }",
                [
                    Integer(55),
                    Integer(60),
                    CompiledFunction(
                        instructions: Array([
                            Bytecode.make(.constant, 1),
                            Bytecode.make(.assignGlobal, 0),
                            Bytecode.make(.getGlobal, 0),
                            Bytecode.make(.returnVal)
                        ].joined()),
                        localsCount: 0
                    )
                ],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.setGlobal, 0),
                    Bytecode.make(.closure, 2, 0),
                    Bytecode.make(.pop)
                ]
            ),
            (
                // This one will throw an error
                "var const = 55; \n fn() { let const = 10; const = 60; const; }",
                [
                    Integer(55),
                    Integer(10),
                    Integer(60),
                    CompiledFunction(
                        instructions: Array([
                            Bytecode.make(.constant, 1),
                            Bytecode.make(.setLocal, 0),
                            Bytecode.make(.constant, 2),
                            Bytecode.make(.assignLocal, 0),
                            Bytecode.make(.getLocal, 0),
                            Bytecode.make(.returnVal)
                        ].joined()),
                        localsCount: 1
                    )
                ],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.setGlobal, 0),
                    Bytecode.make(.closure, 3, 0),
                    Bytecode.make(.pop)
                ]
            )
        ]

        for test in tests {
            do {
                try runCompilerTest(test)
            } catch let error as AssignConstantError {
                XCTAssertEqual(error.description, "Cannot assign to value: \"const\" is a constant")
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }
}
