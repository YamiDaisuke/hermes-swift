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
        let integerTypeBytes = MonkeyTypes.integer.bytes

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

    func testMFloatCompile() throws {
        let tests: [Float64] = [
            64.5,
            255.0,
            -255.255,
            Float64.greatestFiniteMagnitude
        ]

        for test in tests {
            let expectedType = MonkeyTypes.float.rawValue

            let float = MFloat(test)
            let bytes = float.compile()

            XCTAssertEqual(expectedType.hexa, bytes[0..<1].hexa)
            let data = Data(bytes[1..<9])
            let bitPattern = UInt64(bigEndian: data.withUnsafeBytes { $0.load(as: UInt64.self) })
            let value = Float64(bitPattern: bitPattern)
            XCTAssertEqual(test, value)
        }
    }

    func testMFloatDecompile() throws {
        let typeBytes = MonkeyTypes.float.bytes

        let tests: [([Byte], Float64)] = [
            (typeBytes + [0x40, 0x50, 0x20, 0x00, 0x00, 0x00, 0x00, 0x00], 64.5),
            (typeBytes + [0x40, 0x6F, 0xE0, 0x00, 0x00, 0x00, 0x00, 0x00], 255.0),
            (typeBytes + [0xC0, 0x6F, 0xE8, 0x28, 0xF5, 0xC2, 0x8F, 0x5C], -255.255),
            (typeBytes + [0x7F, 0xEF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF], Float64.greatestFiniteMagnitude)
        ]

        for test in tests {
            let float = try MFloat(fromBytes: test.0)
            XCTAssertEqual(test.1, float.value)
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

    func testNullCompile() throws {
        let expectedType = MonkeyTypes.null.rawValue

        let bytes = Null.null.compile()

        XCTAssertEqual(expectedType.hexa, bytes[0..<1].hexa)
        XCTAssertEqual(bytes.count, 1)
    }

    func testNullDecompile() throws {
        let typeBytes = MonkeyTypes.null.bytes
        let tests: [([Byte], Null)] = [
            (typeBytes, .null),
            (typeBytes, .null)
        ]

        for test in tests {
            let null = try Null(fromBytes: test.0)
            XCTAssert(test.1.isEquals(other: null))
        }
    }

    func testMStringCompile() throws {
        let tests = [
            "A",
            "Short",
            "And a normally not quite but enough long",
            "With 🍺",
            "日本語"
        ]

        for test in tests {
            let expectedType = MonkeyTypes.string.rawValue

            let mstring = MString(test)
            let bytes = mstring.compile()

            XCTAssertEqual(expectedType.hexa, bytes[0..<1].hexa)
            XCTAssertEqual(test.lengthOfBytes(using: .utf8), Int(bytes.readInt(bytes: 4, startIndex: 1) ?? 0))
            XCTAssertEqual(test, String(bytes: bytes[5...], encoding: .utf8))
        }
    }

    func testMStringDecompile() throws {
        let typeBytes = MonkeyTypes.string.bytes
        let tests: [([Byte], String)] = [
            (typeBytes + [0, 0, 0, 1] + [0x41], "A"),
            (typeBytes + [0, 0, 0, 5] + [0x53, 0x68, 0x6f, 0x72, 0x74], "Short"),
            (typeBytes + [0, 0, 0, 4] + [0xf0, 0x9f, 0x8d, 0xba], "🍺"),
            // This one includes junk bytes at the end
            (typeBytes + [0, 0, 0, 1] + [0x41, 66, 66, 66, 66], "A"),
            (typeBytes + [0, 0, 0, 9] + [0xe6, 0x97, 0xa5, 0xe6, 0x9c, 0xac, 0xe8, 0xaa, 0x9e], "日本語")
        ]

        for test in tests {
            let mstring = try MString(fromBytes: test.0)
            XCTAssertEqual(test.1, mstring.value)
        }
    }

    func testMArrayCompile() throws {
        let tests: [MArray] = [
            MArray(elements: []),
            MArray(elements: [Integer(1), Integer(2)]),
            MArray(elements: [Integer(1), Boolean.false]),
            MArray(elements: [Boolean.true, MString("false")]),
            MArray(elements: [
                MArray(elements: []),
                MArray(elements: [Integer(1), Integer(2)])
            ])
        ]

        for test in tests {
            let expectedType = MonkeyTypes.array.rawValue

            let bytes = try test.compile()

            XCTAssertEqual(expectedType.hexa, bytes[0..<1].hexa)
            XCTAssertEqual(test.elements.count, Int(bytes.readInt(bytes: 4, startIndex: 1) ?? -1))
            var startIndex = 5
            for element in test.elements {
                if let compilable = element as? Compilable {
                    let elementBytes = try compilable.compile()
                    let current = Array(bytes[startIndex..<(startIndex + elementBytes.count)])
                    XCTAssertEqual(elementBytes, current)
                    startIndex += elementBytes.count
                } else {
                    XCTFail("Element \(element) must be compilable")
                }
            }
        }
    }

    func testMArrayDecompile() throws {
        let typeBytes = MonkeyTypes.array.bytes
        let innerArrayTest1 = try MArray(elements: []).compile()
        let innerArrayTest2 = try MArray(elements: [Integer(1), Integer(2)]).compile()

        let tests: [([Byte], MArray)] = [
            (typeBytes + [0, 0, 0, 0], MArray(elements: [])),
            (
                typeBytes + [0, 0, 0, 2] + Integer(1).compile() + Integer(2).compile(),
                MArray(elements: [Integer(1), Integer(2)])
            ),
            (
                typeBytes + [0, 0, 0, 2] + Integer(1).compile() + Boolean.false.compile(),
                MArray(elements: [Integer(1), Boolean.false])
            ),
            (
                typeBytes + [0, 0, 0, 2] + Boolean.true.compile() + MString("false").compile(),
                MArray(elements: [Boolean.true, MString("false")])
            ),
            (
                typeBytes + [0, 0, 0, 2] + innerArrayTest1 + innerArrayTest2,
                MArray(elements: [
                    MArray(elements: []),
                    MArray(elements: [Integer(1), Integer(2)])
                ])
            )
        ]

        for test in tests {
            let array = try MArray(fromBytes: test.0)
            XCTAssert(test.1.isEquals(other: array))
        }
    }

    func testDecompileTypeError() throws {
        typealias InitFunc = ([UInt8]) throws -> Object
        let tests: [(MonkeyTypes, InitFunc)] = [
            (MonkeyTypes.integer, Null.init),
            (MonkeyTypes.null, Integer.init),
            (MonkeyTypes.null, MFloat.init),
            (MonkeyTypes.null, Boolean.init),
            (MonkeyTypes.null, MString.init),
            (MonkeyTypes.null, MArray.init)
        ]

        for test in tests {
            do {
                let value = try test.1(test.0.bytes)
                XCTFail("This line should not be reached")
                XCTAssertNil(value)
            } catch let error as UnknowValueType {
                XCTAssertEqual("Unknow value type: \(test.0.bytes.hexa)", error.description)
            } catch {
                XCTFail("Unexpected Error")
            }
        }
    }
}
