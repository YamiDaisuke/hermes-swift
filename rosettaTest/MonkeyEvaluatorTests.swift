//
//  MonkeyEvaluatorTests.swift
//  rosettaTest
//
//  Created by Franklin Cruz on 07-01-21.
//

import XCTest

class MonkeyEvaluatorTests: XCTestCase {
    func testEvalInteger() throws {
        let tests = [
            ("5", 5),
            ("10", 10)
        ]

        for test in tests {
            let evaluated = try testEval(input: test.0)
            assertInteger(object: evaluated, expected: test.1)
        }
    }

    func testEvalBoolean() throws {
        let tests = [
            ("true", true),
            ("false", false)
        ]

        for test in tests {
            let evaluated = try testEval(input: test.0)
            assertBoolean(object: evaluated, expected: test.1)
        }
    }

    // MARK: Utils
    func testEval(input: String) throws -> Object? {
        let lexer = MonkeyLexer(withString: input)
        var parser = MonkeyParser(lexer: lexer)

        guard let program = try parser.parseProgram() else {
            return nil
        }
        return MonkeyEvaluator.eval(program: program)
    }

    func assertInteger(object: Object?, expected: Int) {
        let integer = object as? Integer
        XCTAssertNotNil(integer)
        XCTAssertEqual(integer?.value, expected)
    }

    func assertBoolean(object: Object?, expected: Bool) {
        let bool = object as? Boolean
        XCTAssertNotNil(bool)
        XCTAssertEqual(bool?.value, expected)
    }
}
