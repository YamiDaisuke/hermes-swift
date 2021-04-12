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
            -255,
            65536
        ]

        for test in tests {
            let expectedType = MonkeyTypes.integer.rawValue

            let integer = Integer(test)
            let bytes = integer.compile()

            XCTAssertEqual(expectedType.hexa, bytes[0..<1].hexa)
            XCTAssertEqual(test, bytes.readInt(bytes: 4, startIndex: 1))
        }
    }

    func testIntDecompile() throws {
        let integerTypeBytes = withUnsafeBytes(of: MonkeyTypes.integer.rawValue.bigEndian, [Byte].init)

        let tests: [([Byte], Int32)] = [
            (integerTypeBytes + [0, 0, 0, 64], 64),
            (integerTypeBytes + [0, 0, 0, 255], 255),
            // two's complement
            (integerTypeBytes + [255, 255, 255, 1], -255),
            (integerTypeBytes + [0, 1, 0, 0], 65536)
        ]

        for test in tests {
            let integer = try Integer(fromBytes: test.0)
            XCTAssertEqual(test.1, integer.value)
        }
    }

    func testBooleanCompile() throws {
        let tests: [Bool] = [
            true,
            false
        ]

        for test in tests {
            let expectedType = MonkeyTypes.boolean.rawValue

            let boolean = Boolean(test)
            let bytes = boolean.compile()

            XCTAssertEqual(expectedType.hexa, bytes[0..<1].hexa)
            XCTAssertEqual(test ? 1 : 0, bytes.readInt(bytes: 1, startIndex: 1))
        }
    }

    func testBooleanDecompile() throws {
        let typeBytes = MonkeyTypes.boolean.bytes
        let tests: [([Byte], Bool)] = [
            (typeBytes + [1], true),
            (typeBytes + [0], false)
        ]

        for test in tests {
            let boolean = try Boolean(fromBytes: test.0)
            XCTAssertEqual(test.1, boolean.value)
        }
    }
}
