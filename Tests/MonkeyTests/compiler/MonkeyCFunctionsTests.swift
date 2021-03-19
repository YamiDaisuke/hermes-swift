//
//  MonkeyCFunctionsTests.swift
//  MonkeyTests
//
//  Created by Franklin Cruz on 11-03-21.
//

import XCTest
@testable import Rosetta
@testable import MonkeyLang

class MonkeyCFunctionsTests: XCTestCase, CompilerTestsHelpers {
    func testFunctions() throws {
        let tests: [CompilerTestCase] = [
            (
                "fn() { return 5 + 10; }",
                [
                    Integer(5),
                    Integer(10),
                    CompiledFunction(
                        instructions: Array([
                            Bytecode.make(.constant, 0),
                            Bytecode.make(.constant, 1),
                            Bytecode.make(.add),
                            Bytecode.make(.returnVal)
                        ].joined())
                    )
                ],
                [
                    Bytecode.make(.constant, 2),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "fn() { 1; 2 }",
                [
                    Integer(1),
                    Integer(2),
                    CompiledFunction(
                        instructions: Array([
                            Bytecode.make(.constant, 0),
                            Bytecode.make(.pop),
                            Bytecode.make(.constant, 1),
                            Bytecode.make(.returnVal)
                        ].joined())
                    )
                ],
                [
                    Bytecode.make(.constant, 2),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "fn() { }",
                [
                    CompiledFunction(instructions: Bytecode.make(.return), localsCount: 0)
                ],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.pop)
                ]
            )
        ]

        try runCompilerTests(tests)
    }

    func testFunctionCalls() throws {
        let tests: [CompilerTestCase] = [
            (
                "fn() { 24 }();",
                [
                    Integer(24),
                    CompiledFunction(
                        instructions: Array([
                            Bytecode.make(.constant, 0),
                            Bytecode.make(.returnVal)
                        ].joined())
                    )
                ],
                [
                    Bytecode.make(.constant, 1),
                    Bytecode.make(.call, 0),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "let noArg = fn() { 24 }; \n noArg()",
                [
                    Integer(24),
                    CompiledFunction(
                        instructions: Array([
                            Bytecode.make(.constant, 0),
                            Bytecode.make(.returnVal)
                        ].joined())
                    )
                ],
                [
                    Bytecode.make(.constant, 1),
                    Bytecode.make(.setGlobal, 0),
                    Bytecode.make(.getGlobal, 0),
                    Bytecode.make(.call, 0),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "let oneArg = fn(a) { a }; oneArg(24);",
                [
                    CompiledFunction(
                        instructions: Array([
                            Bytecode.make(.getLocal, 0),
                            Bytecode.make(.returnVal)
                        ].joined())
                    ),
                    Integer(24)
                ],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.setGlobal, 0),
                    Bytecode.make(.getGlobal, 0),
                    Bytecode.make(.constant, 1),
                    Bytecode.make(.call, 1),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "let manyArg = fn(a, b, c) { a; b; c; }; manyArg(24, 25, 26);",
                [
                    CompiledFunction(
                        instructions: Array([
                            Bytecode.make(.getLocal, 0),
                            Bytecode.make(.pop),
                            Bytecode.make(.getLocal, 1),
                            Bytecode.make(.pop),
                            Bytecode.make(.getLocal, 2),
                            Bytecode.make(.returnVal)
                        ].joined())
                    ),
                    Integer(24),
                    Integer(25),
                    Integer(26)
                ],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.setGlobal, 0),
                    Bytecode.make(.getGlobal, 0),
                    Bytecode.make(.constant, 1),
                    Bytecode.make(.constant, 2),
                    Bytecode.make(.constant, 3),
                    Bytecode.make(.call, 3),
                    Bytecode.make(.pop)
                ]
            )
        ]

        try runCompilerTests(tests)
    }

    func testBuiltins() throws {
        let tests: [CompilerTestCase] = [
            (
                "len([]); push([], 1)",
                [Integer(1)],
                [
                    Bytecode.make(.getBuiltin, 0),
                    Bytecode.make(.array, 0),
                    Bytecode.make(.call, 1),
                    Bytecode.make(.pop),
                    Bytecode.make(.getBuiltin, 5),
                    Bytecode.make(.array, 0),
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.call, 2),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "fn () { len([]) }",
                [
                    CompiledFunction(
                        instructions: Array([
                            Bytecode.make(.getBuiltin, 0),
                            Bytecode.make(.array, 0),
                            Bytecode.make(.call, 1),
                            Bytecode.make(.returnVal)
                        ].joined())
                    )
                ],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.pop)
                ]
            )
        ]

        try runCompilerTests(tests)
    }
}
