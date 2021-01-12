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
            ("10", 10),
            ("-5", -5),
            ("-10", -10),
            ("5 + 5 + 5 + 5 - 10", 10),
            ("2 * 2 * 2 * 2 * 2", 32),
            ("-50 + 100 + -50", 0),
            ("5 * 2 + 10", 20),
            ("5 + 2 * 10", 25),
            ("20 + 2 * -10", 0),
            ("50 / 2 * 2 + 10", 60),
            ("2 * (5 + 10)", 30),
            ("3 * 3 * 3 + 10", 37),
            ("3 * (3 * 3) + 10", 37),
            ("(5 + 10 * 2 + 15 / 3) * 2 + -10", 50)
        ]

        for test in tests {
            let evaluated = try testEval(input: test.0)
            assertInteger(object: evaluated, expected: test.1)
        }
    }

    func testEvalBoolean() throws {
        let tests = [
            ("true", true),
            ("false", false),
            ("1 < 2", true),
            ("1 > 2", false),
            ("1 < 1", false),
            ("1 > 1", false),
            ("1 == 1", true),
            ("1 != 1", false),
            ("1 == 2", false),
            ("1 != 2", true),
            ("true == true", true),
            ("false == false", true),
            ("true == false", false),
            ("true != false", true),
            ("false != true", true),
            ("(1 < 2) == true", true),
            ("(1 < 2) == false", false),
            ("(1 > 2) == true", false),
            ("(1 > 2) == false", true),
            ("0 == false", true),
            ("0 == true", false),
            ("80 == false", false),
            ("10 == true", true)
        ]

        for test in tests {
            let evaluated = try testEval(input: test.0)
            assertBoolean(object: evaluated, expected: test.1)
        }
    }

    func testBangOperator() throws {
        let tests = [
            ("!true", false),
            ("!false", true),
            ("!5", false),
            ("!!true", true),
            ("!!false", false),
            ("!!5", true)
        ]

        for test in tests {
            let evaluated = try testEval(input: test.0)
            assertBoolean(object: evaluated, expected: test.1)
        }
    }

    func testIfElseExpression() throws {
        let tests = [
            ("if (true) { 10 }", 10),
            ("if (false) { 10 }", nil),
            ("if (1) { 10 }", 10),
            ("if (1 < 2) { 10 }", 10),
            ("if (1 > 2) { 10 }", nil),
            ("if (1 > 2) { 10 } else { 20 }", 20),
            ("if (1 < 2) { 10 } else { 20 }", 10)
        ]

        for test in tests {
            let evaluated = try testEval(input: test.0)
            if let expected = test.1 {
                assertInteger(object: evaluated, expected: expected)
            } else {
                let isNull = Null.null == evaluated
                XCTAssert(isNull.value)
            }
        }
    }

    func testReturnStatement() throws {
        let tests = [
            ("return 10;", 10),
            ("return 10; 9;", 10),
            ("return 2 * 5; 9;", 10),
            ("9; return 2 * 5; 9;", 10),
            ("if (1 < 10) { if (1 < 10) { return 10; } return 1; }", 10)
        ]

        for test in tests {
            let evaluated = try testEval(input: test.0)
            assertInteger(object: evaluated, expected: test.1)
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
