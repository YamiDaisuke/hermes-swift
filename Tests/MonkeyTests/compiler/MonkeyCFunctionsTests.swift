//
//  MonkeyCFunctionsTests.swift
//  MonkeyTests
//
//  Created by Franklin Cruz on 11-03-21.
//

import XCTest
@testable import Rosetta
@testable import MonkeyLang

// swiftlint:disable type_body_length function_body_length file_length
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
                    Bytecode.make(.closure, 2, 0),
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
                    Bytecode.make(.closure, 2, 0),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "fn() { }",
                [
                    CompiledFunction(instructions: Bytecode.make(.return), localsCount: 0)
                ],
                [
                    Bytecode.make(.closure, 0, 0),
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
                    Bytecode.make(.closure, 1, 0),
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
                    Bytecode.make(.closure, 1, 0),
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
                    Bytecode.make(.closure, 0, 0),
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
                    Bytecode.make(.closure, 0, 0),
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
                    Bytecode.make(.closure, 0, 0),
                    Bytecode.make(.pop)
                ]
            )
        ]

        try runCompilerTests(tests)
    }

    func testClosures() throws {
        let tests: [CompilerTestCase] = [
            (
                """
                fn(a) {
                    fn(b) {
                        a + b
                    }
                }
                """,
                [
                    CompiledFunction(
                        instructions: Array([
                            Bytecode.make(.getFree, 0),
                            Bytecode.make(.getLocal, 0),
                            Bytecode.make(.add),
                            Bytecode.make(.returnVal)
                        ].joined())
                    ),
                    CompiledFunction(
                        instructions: Array([
                            Bytecode.make(.getLocal, 0),
                            Bytecode.make(.closure, 0, 1),
                            Bytecode.make(.returnVal)
                        ].joined())
                    )
                ],
                [
                    Bytecode.make(.closure, 1, 0),
                    Bytecode.make(.pop)
                ]
            ),
            (
                """
                fn(a) {
                    fn(b) {
                        fn(c) {
                            a + b + c
                        }
                    }
                }
                """,
                [
                    CompiledFunction(
                        instructions: Array([
                            Bytecode.make(.getFree, 0),
                            Bytecode.make(.getFree, 1),
                            Bytecode.make(.add),
                            Bytecode.make(.getLocal, 0),
                            Bytecode.make(.add),
                            Bytecode.make(.returnVal)
                        ].joined())
                    ),
                    CompiledFunction(
                        instructions: Array([
                            Bytecode.make(.getFree, 0),
                            Bytecode.make(.getLocal, 0),
                            Bytecode.make(.closure, 0, 2),
                            Bytecode.make(.returnVal)
                        ].joined())
                    ),
                    CompiledFunction(
                        instructions: Array([
                            Bytecode.make(.getLocal, 0),
                            Bytecode.make(.closure, 1, 1),
                            Bytecode.make(.returnVal)
                        ].joined())
                    )
                ],
                [
                    Bytecode.make(.closure, 2, 0),
                    Bytecode.make(.pop)
                ]
            ),
            (
                """
                let global = 55;
                fn() {
                    let a = 66;
                    fn() {
                        let b = 77;
                        fn() {
                            let c = 88;
                            global + a + b + c;
                        }
                    }
                }
                """,
                [
                    Integer(55),
                    Integer(66),
                    Integer(77),
                    Integer(88),
                    CompiledFunction(
                        instructions: Array([
                            Bytecode.make(.constant, 3),
                            Bytecode.make(.setLocal, 0),
                            Bytecode.make(.getGlobal, 0),
                            Bytecode.make(.getFree, 0),
                            Bytecode.make(.add),
                            Bytecode.make(.getFree, 1),
                            Bytecode.make(.add),
                            Bytecode.make(.getLocal, 0),
                            Bytecode.make(.add),
                            Bytecode.make(.returnVal)
                        ].joined())
                    ),
                    CompiledFunction(
                        instructions: Array([
                            Bytecode.make(.constant, 2),
                            Bytecode.make(.setLocal, 0),
                            Bytecode.make(.getFree, 0),
                            Bytecode.make(.getLocal, 0),
                            Bytecode.make(.closure, 4, 2),
                            Bytecode.make(.returnVal)
                        ].joined())
                    ),
                    CompiledFunction(
                        instructions: Array([
                            Bytecode.make(.constant, 1),
                            Bytecode.make(.setLocal, 0),
                            Bytecode.make(.getLocal, 0),
                            Bytecode.make(.closure, 5, 1),
                            Bytecode.make(.returnVal)
                        ].joined())
                    )
                ],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.setGlobal, 0),
                    Bytecode.make(.closure, 6, 0),
                    Bytecode.make(.pop)
                ]
            )
        ]

        try runCompilerTests(tests)
    }

    func testRecursiveFunction() throws {
        let tests: [CompilerTestCase] = [
            (
                """
                let countDown = fn(x) { countDown(x - 1); };
                countDown(1);
                """,
                [
                    Integer(1),
                    CompiledFunction(
                        instructions: Array([
                            Bytecode.make(.currentClosure),
                            Bytecode.make(.getLocal, 0),
                            Bytecode.make(.constant, 0),
                            Bytecode.make(.sub),
                            Bytecode.make(.call, 1),
                            Bytecode.make(.returnVal)
                        ].joined())
                    ),
                    Integer(1)
                ],
                [
                    Bytecode.make(.closure, 1, 0),
                    Bytecode.make(.setGlobal, 0),
                    Bytecode.make(.getGlobal, 0),
                    Bytecode.make(.constant, 2),
                    Bytecode.make(.call, 1),
                    Bytecode.make(.pop)
                ]
            ),
            (
                """
                let wrapper = fn() {
                    let countDown = fn(x) { countDown(x - 1); };
                    countDown(1);
                };
                wrapper();
                """,
                [
                    Integer(1),
                    CompiledFunction(
                        instructions: Array([
                            Bytecode.make(.currentClosure),
                            Bytecode.make(.getLocal, 0),
                            Bytecode.make(.constant, 0),
                            Bytecode.make(.sub),
                            Bytecode.make(.call, 1),
                            Bytecode.make(.returnVal)
                        ].joined())
                    ),
                    Integer(1),
                    CompiledFunction(
                        instructions: Array([
                            Bytecode.make(.closure, 1, 0),
                            Bytecode.make(.setLocal, 0),
                            Bytecode.make(.getLocal, 0),
                            Bytecode.make(.constant, 2),
                            Bytecode.make(.call, 1),
                            Bytecode.make(.returnVal)
                        ].joined())
                    )
                ],
                [
                    Bytecode.make(.closure, 3, 0),
                    Bytecode.make(.setGlobal, 0),
                    Bytecode.make(.getGlobal, 0),
                    Bytecode.make(.call, 0),
                    Bytecode.make(.pop)
                ]
            )
        ]

        try runCompilerTests(tests)
    }
}
