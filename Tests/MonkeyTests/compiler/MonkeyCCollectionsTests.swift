//
//  MonkeyCCollectionsTests.swift
//  MonkeyTests
//
//  Created by Franklin Cruz on 11-03-21.
//

import XCTest
@testable import Hermes
@testable import MonkeyLang

class MonkeyCCollectionsTests: XCTestCase, CompilerTestsHelpers {
    func testArrayLiterals() throws {
        let tests: [CompilerTestCase] = [
            (
                "[]",
                [],
                [
                    Bytecode.make(.array, 0),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "[1, 2, 3]",
                [Integer(1), Integer(2), Integer(3)],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.constant, 1),
                    Bytecode.make(.constant, 2),
                    Bytecode.make(.array, 3),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "[1 + 2, 3 - 4, 5 * 6]",
                [Integer(1), Integer(2), Integer(3), Integer(4), Integer(5), Integer(6)],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.constant, 1),
                    Bytecode.make(.add),
                    Bytecode.make(.constant, 2),
                    Bytecode.make(.constant, 3),
                    Bytecode.make(.sub),
                    Bytecode.make(.constant, 4),
                    Bytecode.make(.constant, 5),
                    Bytecode.make(.mul),
                    Bytecode.make(.array, 3),
                    Bytecode.make(.pop)
                ]
            )
        ]

        try runCompilerTests(tests)
    }

    func testHashLiterals() throws {
        let tests: [CompilerTestCase] = [
            (
                "{}",
                [],
                [
                    Bytecode.make(.hash, 0),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "{1: 2, 3: 4, 5: 6}",
                [Integer(1), Integer(2), Integer(3), Integer(4), Integer(5), Integer(6)],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.constant, 1),
                    Bytecode.make(.constant, 2),
                    Bytecode.make(.constant, 3),
                    Bytecode.make(.constant, 4),
                    Bytecode.make(.constant, 5),
                    Bytecode.make(.hash, 6),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "{1: 2 + 3, 4: 5 * 6}",
                [Integer(1), Integer(2), Integer(3), Integer(4), Integer(5), Integer(6)],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.constant, 1),
                    Bytecode.make(.constant, 2),
                    Bytecode.make(.add),
                    Bytecode.make(.constant, 3),
                    Bytecode.make(.constant, 4),
                    Bytecode.make(.constant, 5),
                    Bytecode.make(.mul),
                    Bytecode.make(.hash, 4),
                    Bytecode.make(.pop)
                ]
            )
        ]

        try runCompilerTests(tests)
    }

    func testIndexExpressions() throws {
        let tests: [CompilerTestCase] = [
            (
                "[1, 2, 3][1 + 1]",
                [Integer(1), Integer(2), Integer(3), Integer(1), Integer(1)],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.constant, 1),
                    Bytecode.make(.constant, 2),
                    Bytecode.make(.array, 3),
                    Bytecode.make(.constant, 3),
                    Bytecode.make(.constant, 4),
                    Bytecode.make(.add),
                    Bytecode.make(.index),
                    Bytecode.make(.pop)
                ]
            ),
            (
                "{1: 2}[2 - 1]",
                [Integer(1), Integer(2), Integer(2), Integer(1)],
                [
                    Bytecode.make(.constant, 0),
                    Bytecode.make(.constant, 1),
                    Bytecode.make(.hash, 2),
                    Bytecode.make(.constant, 2),
                    Bytecode.make(.constant, 3),
                    Bytecode.make(.sub),
                    Bytecode.make(.index),
                    Bytecode.make(.pop)
                ]
            )
        ]

        try runCompilerTests(tests)
    }
}
