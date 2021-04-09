//
//  CompilableTests.swift
//  HermesTests
//
//  Created by Franklin Cruz on 09-04-21.
//

import XCTest
@testable import Hermes
@testable import MonkeyLang

class CompilableTests: XCTestCase {
    func testIntCompile() throws {
        let tests: [Int32] = [
            64,
            255,
            -255
        ]

        for test in tests {
            let expectedType = MonkeyTypes.integer.rawValue

            let integer = Integer(test)
            let bytes = integer.compile()

            XCTAssertEqual(expectedType.hexa, bytes[0..<4].hexa)
            XCTAssertEqual(UInt32(32).hexa, bytes[4..<8].hexa)
            XCTAssertEqual(test, bytes.readInt(bytes: 4, startIndex: 8))
        }
    }
}
