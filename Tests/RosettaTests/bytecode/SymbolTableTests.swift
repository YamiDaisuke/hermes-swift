//
//  SymbolTableTests.swift
//  RosettaTests
//
//  Created by Franklin Cruz on 20-02-21.
//

import XCTest
@testable import Rosetta

class SymbolTableTests: XCTestCase {
    func testDefine() throws {
        let expected: [String: Symbol] = [
            "a": Symbol(name: "a", scope: .global, index: 0),
            "b": Symbol(name: "b", scope: .global, index: 1)
        ]
        var global = SymbolTable()
        let a = global.define("a")
        XCTAssertEqual(expected["a"], a)
        let b = global.define("b")
        XCTAssertEqual(expected["b"], b)
    }

    func testResolveGlobal() throws {
        let expected = [
            Symbol(name: "a", scope: .global, index: 0),
            Symbol(name: "b", scope: .global, index: 1)
        ]

        var global = SymbolTable()
        global.define("a")
        global.define("b")

        for symbol in expected {
            let result = try global.resolve(symbol.name)
            XCTAssertEqual(result, symbol)
        }
    }
}
