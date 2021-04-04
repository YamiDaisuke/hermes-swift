//
//  EvaluateOperationsTests.swift
//  MonkeyTests
//
//  Created by Franklin Cruz on 19-01-21.
//

import XCTest
@testable import Hermes
@testable import MonkeyLang

class EvaluateOperationsTests: XCTestCase {
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
            let evaluated = try Utils.testEval(input: test.0, environment: Environment())
            MKAssertInteger(object: evaluated, expected: test.1)
        }
    }

    func testEvalFloat() throws {
        let tests = [
            ("5.0", 5.0),
            ("0.10", 0.10),
            ("-5.5", -5.5),
            ("-0.10", -0.10),
            ("2.5 + 2.5", 5.0),
            ("2.5 + 2", 4.5),
            ("2.0 * 1.0", 2.0),
            ("2.0 * 1", 2.0),
            ("5.0 / 2.0", 2.5),
            ("5.0 / 2", 2.5),
            ("5.0 - 2.0", 3.0),
            ("5.0 - 2", 3.0)
        ]

        for test in tests {
            let evaluated = try Utils.testEval(input: test.0, environment: Environment())
            MKAssertFloat(object: evaluated, expected: test.1)
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
            ("1 <= 2", true),
            ("1 >= 2", false),
            ("1 <= 1", true),
            ("1 >= 1", true),
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
            ("10 == true", true),

            ("80.0 == false", false),
            ("10.0 == true", true),
            ("0.0 == false", true),
            ("0.0 == true", false),
        ]

        for test in tests {
            let evaluated = try Utils.testEval(input: test.0, environment: Environment())
            MKAssertBoolean(object: evaluated, expected: test.1)
        }
    }

    func testEvalFloatComparison() throws {
        let tests = [
            ("(1.0 > 2) == true", false),
            ("(1 > 2.0) == false", true),
            ("(1.0 < 2) == true", true),
            ("(1 < 2.0) == false", false),

            ("(2.0 > 1) == true", true),
            ("(2 > 1.0) == false", false),
            ("(2.0 < 1) == true", false),
            ("(2 < 1.0) == false", true),

            ("(1.0 > 2.0) == true", false),
            ("(1.0 > 2.0) == false", true),
            ("(1.0 < 2.0) == true", true),
            ("(1.0 < 2.0) == false", false),

            ("(2.5 > 1.5) == true", true),
            ("(2.5 > 1.5) == false", false),
            ("(2.5 < 1.5) == true", false),
            ("(2.5 < 1.5) == false", true),

            ("(1.0 >= 2) == true", false),
            ("(1 >= 2.0) == false", true),
            ("(1.0 <= 2) == true", true),
            ("(1 <= 2.0) == false", false),
            ("(1 <= 1.0) == true", true),

            ("(2.0 >= 1) == true", true),
            ("(2 >= 1.0) == false", false),
            ("(2.0 <= 1) == true", false),
            ("(2 <= 1.0) == false", true),
            ("(2 <= 2.0) == true", true),

            ("(1.0 >= 2.0) == true", false),
            ("(1.0 >= 2.0) == false", true),
            ("(1.0 <= 2.0) == true", true),
            ("(1.0 <= 2.0) == false", false),
            ("(1.0 <= 1.0) == true", true),

            ("(2.5 >= 1.5) == true", true),
            ("(2.5 >= 1.5) == false", false),
            ("(2.5 <= 1.5) == true", false),
            ("(2.5 <= 1.5) == false", true),
            ("(2.5 <= 2.5) == true", true),

            ("(1.0 == 2) == true", false),
            ("(1.0 == 1) == true", true),
            ("(1.0 == 2.0) == true", false),
            ("(1.0 == 1.0) == true", true),

            ("(1.0 != 2) == true", true),
            ("(1.0 != 1) == true", false),
            ("(1.0 != 2.0) == true", true),
            ("(1.0 != 1.0) == true", false)
        ]

        for test in tests {
            let evaluated = try Utils.testEval(input: test.0, environment: Environment())
            MKAssertBoolean(object: evaluated, expected: test.1)
        }
    }

    func testEvalStringConcatention() throws {
        let tests = [
            (#""Hello" + " " + "World!""#, "Hello World!"),
            (#""Hello " + 10"#, "Hello 10"),
            (#""Hello " + true"#, "Hello true"),
            (#"10 + " Hello""#, "10 Hello"),
            (#"true + " Hello""#, "true Hello"),
            (#"1.5 + " Hello""#, "1.5 Hello"),
        ]

        for test in tests {
            let evaluated = try Utils.testEval(input: test.0, environment: Environment())
            let string = evaluated as? MString
            XCTAssertNotNil(string)
            XCTAssertEqual(string?.value, test.1)
        }
    }

    func testEvalStringCompare() throws {
        let tests = [
            (#""Hello" == "World!""#, false),
            (#""Hello" == "Hello""#, true),
            (#""Hello" != "World!""#, true),
            (#""Hello" != "Hello""#, false),
            (#""Hello" == 10"#, false),
            (#""Hello" != 10"#, true),
            (#""10" == 10"#, false),
            (#""10" != 10"#, true),
            (#""10" == 10.0"#, false),
            (#""10" != 10.0"#, true),
            (#""Hello" == true"#, true),
            ("\"\" == false", true)
        ]

        for test in tests {
            let evaluated = try Utils.testEval(input: test.0, environment: Environment())
            MKAssertBoolean(object: evaluated, expected: test.1)
        }
    }

    func testBangOperator() throws {
        let tests = [
            ("!true", false),
            ("!false", true),
            ("!5", false),
            ("!!true", true),
            ("!!false", false),
            ("!!5", true),
            ("!!5.0", true),
            ("!5.0", false)
        ]

        for test in tests {
            let evaluated = try Utils.testEval(input: test.0, environment: Environment())
            MKAssertBoolean(object: evaluated, expected: test.1)
        }
    }
}
