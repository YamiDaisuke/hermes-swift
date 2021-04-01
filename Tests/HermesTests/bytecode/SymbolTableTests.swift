//
//  SymbolTableTests.swift
//  RosettaTests
//
//  Created by Franklin Cruz on 20-02-21.
//

import XCTest
@testable import Hermes

class SymbolTableTests: XCTestCase {
    func testDefine() throws {
        let expected: [String: Symbol] = [
            "a": Symbol(name: "a", scope: .global, index: 0),
            "b": Symbol(name: "b", scope: .global, index: 1),

            "c": Symbol(name: "c", scope: .local, index: 0),
            "d": Symbol(name: "d", scope: .local, index: 1),
            "e": Symbol(name: "e", scope: .local, index: 0),
            "f": Symbol(name: "f", scope: .local, index: 1)
        ]
        let global = SymbolTable()
        let a = try global.define("a")
        XCTAssertEqual(expected["a"], a)
        let b = try global.define("b")
        XCTAssertEqual(expected["b"], b)

        let firstLocal = SymbolTable(global)
        let c = try firstLocal.define("c")
        XCTAssertEqual(expected["c"], c)
        let d = try firstLocal.define("d")
        XCTAssertEqual(expected["d"], d)

        let secondLocal = SymbolTable(global)
        let e = try secondLocal.define("e")
        XCTAssertEqual(expected["e"], e)
        let f = try secondLocal.define("f")
        XCTAssertEqual(expected["f"], f)
    }

    func testResolveGlobal() throws {
        let expected = [
            Symbol(name: "a", scope: .global, index: 0),
            Symbol(name: "b", scope: .global, index: 1)
        ]

        let global = SymbolTable()
        try global.define("a")
        try global.define("b")

        for symbol in expected {
            let result = try global.resolve(symbol.name)
            XCTAssertEqual(result, symbol)
        }
    }

    func testResolveLocal() throws {
        let global = SymbolTable()
        try global.define("a")
        try global.define("b")

        let local = SymbolTable(global)
        try local.define("c")
        try local.define("d")

        let tests = [
            Symbol(name: "a", scope: .global, index: 0),
            Symbol(name: "b", scope: .global, index: 1),
            Symbol(name: "c", scope: .local, index: 0),
            Symbol(name: "d", scope: .local, index: 1)
        ]

        for expected in tests {
            let result = try local.resolve(expected.name)
            XCTAssertEqual(result, expected)
        }
    }

    func testResolveNestedLocal() throws {
        let global = SymbolTable()
        try global.define("a")
        try global.define("b")

        let firstLocal = SymbolTable(global)
        try firstLocal.define("c")
        try firstLocal.define("d")

        let secondLocal = SymbolTable(firstLocal)
        try secondLocal.define("e")
        try secondLocal.define("f")

        let tests = [
            (
                firstLocal,
                [
                    Symbol(name: "a", scope: .global, index: 0),
                    Symbol(name: "b", scope: .global, index: 1),
                    Symbol(name: "c", scope: .local, index: 0),
                    Symbol(name: "d", scope: .local, index: 1)
                ]
            ),
            (
                secondLocal,
                [
                    Symbol(name: "a", scope: .global, index: 0),
                    Symbol(name: "b", scope: .global, index: 1),
                    Symbol(name: "e", scope: .local, index: 0),
                    Symbol(name: "f", scope: .local, index: 1)
                ]
            )
        ]

        for test in tests {
            for expected in test.1 {
                let result = try test.0.resolve(expected.name)
                XCTAssertEqual(result, expected)
            }
        }
    }

    func testResolveBuiltins() throws {
        let global = SymbolTable()
        let firstLocal = SymbolTable(global)
        let secondLocal = SymbolTable(firstLocal)

        let expected = [
            Symbol(name: "a", scope: .builtin, index: 0),
            Symbol(name: "c", scope: .builtin, index: 1),
            Symbol(name: "e", scope: .builtin, index: 2),
            Symbol(name: "f", scope: .builtin, index: 3)
        ]

        for index in 0..<expected.count {
            let expect = expected[index]
            try global.defineBuiltin(expect.name, index: index)
        }

        for table in [global, firstLocal, secondLocal] {
            for expect in expected {
                let result = try table.resolve(expect.name)
                XCTAssertEqual(result, expect)
            }
        }
    }

    func testResolveFree() throws {
        let global = SymbolTable()
        try global.define("a")
        try global.define("b")

        let firstLocal = SymbolTable(global)
        try firstLocal.define("c")
        try firstLocal.define("d")

        let secondLocal = SymbolTable(firstLocal)
        try secondLocal.define("e")
        try secondLocal.define("f")

        let tests = [
            (
                firstLocal,
                [
                    Symbol(name: "a", scope: .global, index: 0),
                    Symbol(name: "b", scope: .global, index: 1),
                    Symbol(name: "c", scope: .local, index: 0),
                    Symbol(name: "d", scope: .local, index: 1)
                ],
                []
            ),
            (
                secondLocal,
                [
                    Symbol(name: "a", scope: .global, index: 0),
                    Symbol(name: "b", scope: .global, index: 1),
                    Symbol(name: "c", scope: .free, index: 0),
                    Symbol(name: "d", scope: .free, index: 1),
                    Symbol(name: "e", scope: .local, index: 0),
                    Symbol(name: "f", scope: .local, index: 1)
                ],
                [
                    Symbol(name: "c", scope: .free, index: 0),
                    Symbol(name: "d", scope: .free, index: 1)
                ]
            )
        ]

        for test in tests {
            for sym in test.1 {
                let result = try test.0.resolve(sym.name)
                XCTAssertEqual(sym, result)
            }

            XCTAssertEqual(test.0.freeSymbols.count, test.2.count)

            for sym in test.2 {
                let result = try test.0.resolve(sym.name)
                XCTAssertEqual(sym, result)
            }
        }
    }

    func testResolveUnresolvavleFree() throws {
        let global = SymbolTable()
        try global.define("a")

        let firstLocal = SymbolTable(global)
        try firstLocal.define("c")

        let secondLocal = SymbolTable(firstLocal)
        try secondLocal.define("e")
        try secondLocal.define("f")

        let expected = [
            Symbol(name: "a", scope: .global, index: 0),
            Symbol(name: "c", scope: .free, index: 0),
            Symbol(name: "e", scope: .local, index: 0),
            Symbol(name: "f", scope: .local, index: 1)
        ]

        for expect in expected {
            let result = try secondLocal.resolve(expect.name)
            XCTAssertEqual(result, expect)
        }

        let unresolved = [
            "b",
            "d"
        ]

        for name in unresolved {
            let result = try? secondLocal.resolve(name)
            XCTAssertNil(result)
        }
    }

    func testDefineAndResolveFunctionName() throws {
        let global = SymbolTable()
        try global.defineFunctionName("a")

        let expected = Symbol(name: "a", scope: .function, index: 0)
        let result = try global.resolve(expected.name)
        XCTAssertEqual(result, expected)
    }

    func testShadowingFunctionName() throws {
        let global = SymbolTable()
        try global.defineFunctionName("a")
        try global.define("a")

        let expected = Symbol(name: "a", scope: .global, index: 0)
        let result = try global.resolve(expected.name)
        XCTAssertEqual(result, expected)
    }
}
