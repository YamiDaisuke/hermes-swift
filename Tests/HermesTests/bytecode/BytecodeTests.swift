//
//  BytecodeTests.swift
//  HermesTests
//
//  Created by Franklin Cruz on 31-01-21.
//

import XCTest
@testable import Hermes

class BytecodeTests: XCTestCase {
    typealias BaseType = Any
    typealias Test = (opCode: OpCodes, operands: [Int32], expected: [Byte])

    func testMake() {
        let tests: [Test] = [
            (OpCodes.constant, [65534], [OpCodes.constant.rawValue, 255, 254]),
            (OpCodes.add, [], [OpCodes.add.rawValue]),
            (OpCodes.getLocal, [255], [OpCodes.getLocal.rawValue, 255]),
            (OpCodes.closure, [65534, 255], [OpCodes.closure.rawValue, 255, 254, 255])
        ]
        for test in tests {
            let instructions = Bytecode.make(test.opCode, operands: test.operands)
            XCTAssertEqual(instructions.count, test.expected.count)
            for index in 0..<test.expected.count {
                XCTAssertEqual(instructions[index], test.expected[index])
            }
        }
    }

    func testInstructionsDescription() {
        var instructions: Instructions = []
        instructions.append(contentsOf: Bytecode.make(.constant, 1))
        instructions.append(contentsOf: Bytecode.make(.constant, 2))
        instructions.append(contentsOf: Bytecode.make(.constant, 65535))
        instructions.append(contentsOf: Bytecode.make(.add))
        instructions.append(contentsOf: Bytecode.make(.getLocal, 1))
        instructions.append(contentsOf: Bytecode.make(.currentClosure))
        instructions.append(contentsOf: Bytecode.make(.closure, 65535, 255))

        let expected = """
        0000 OpConstant          1
        0003 OpConstant          2
        0006 OpConstant          65535
        0009 OpAdd
        0010 OpGetLocal          1
        0012 OpCurrentClosure
        0013 OpClosure           65535 255
        """

        print(instructions.description)
        XCTAssertEqual(instructions.description, expected)
    }

    func testReadOperands() {
        let tests: [(OpCodes, [Int32], Int)] = [
            (.constant, [65535], 2),
            (.getLocal, [255], 1),
            (.closure, [65535, 255], 3)
        ]

        for test in tests {
            let instruction = Bytecode.make(test.0, operands: test.1)
            let definition = OperationDefinition[test.0]
            XCTAssertNotNil(definition)

            let operandsRead = Bytecode.readOperands(
                // swiftlint:disable force_unwrapping
                definition!,
                instructions: Instructions(instruction[1...])
            )
            XCTAssertEqual(operandsRead.count, test.2)
            XCTAssertEqual(operandsRead.values, test.1)
        }
    }

    func testToInt() {
        let tests: [(Instructions, Int32)] = [
            ([255, 254], 65534),
            ([255, 255], 65535),
            ([0, 255], 255),
            ([255, 0], 65280),
            ([255, 255, 0], 16776960),
            ([0, 255, 255, 0], 16776960)
        ]

        for test in tests {
            let value = test.0.readInt(bytes: test.0.count)
            XCTAssertEqual(value, test.1)
        }
    }
}
