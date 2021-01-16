//
//  MonkeyEvaluatorTests.swift
//  rosettaTest
//
//  Created by Franklin Cruz on 07-01-21.
//

import XCTest
@testable import Rosetta
@testable import MonkeyLang

class MonkeyEvaluatorTests: XCTestCase {
    var environment: Environment<Object>!

    override func setUp() {
        self.environment = Environment()
    }

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

    func testEvalStrings() throws {
        let input = "\"Hello World!\""
        let evaluated = try testEval(input: input)
        let string = evaluated as? MString
        XCTAssertNotNil(string)
        XCTAssertEqual(string?.value, "Hello World!")
        XCTAssertEqual(string?.description, "Hello World!")
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

    func testEvaluatorErrors() throws {
        let tests = [
            ("5 + true;", "Can't apply operator \"+\" to Integer and Boolean at Line: 1, Column: 2"),
            ("5; 5 + true; 5;", "Can't apply operator \"+\" to Integer and Boolean at Line: 1, Column: 5"),
            ("-true;", "Can't apply operator \"-\" to Boolean at Line: 1, Column: 0"),
            ("true + false;", "Can't apply operator \"+\" to Boolean and Boolean at Line: 1, Column: 5"),
            ("5; true + true; 5", "Can't apply operator \"+\" to Boolean and Boolean at Line: 1, Column: 8"),
            ("if (10 > 1) { true + false; }",
             "Can't apply operator \"+\" to Boolean and Boolean at Line: 1, Column: 19"),
            ("if (10 > 1) { if (10 > 1) { return true + false; } return 1; }",
             "Can't apply operator \"+\" to Boolean and Boolean at Line: 1, Column: 40"),
            ("foobar", "\"foobar\" is not defined at Line: 1, Column: 0")
        ]

        for test in tests {
            do {
                _ = try testEval(input: test.0)
            } catch let error as EvaluatorError {
                XCTAssertEqual(error.description, test.1)
            }
        }
    }

    func testLetStatement() throws {
        let tests = [
            ("let a = 5; a;", 5),
            ("let a = 5 * 5; a;", 25),
            ("let a = 5; let b = a; b;", 5),
            ("let a = 5; let b = a; let c = a + b + 5; c;", 15)
        ]

        for test in tests {
            let evaluated = try testEval(input: test.0)
            assertInteger(object: evaluated, expected: test.1)
        }
    }

    func testFunctionObject() throws {
        let input = "fn(x) { x + 2; };"
        let evaluated = try testEval(input: input)
        let function = evaluated as? Function
        XCTAssertNotNil(function)
        XCTAssertEqual(function?.parameters.count, 1)
        XCTAssertEqual(function?.parameters.first, "x")
        XCTAssertEqual(function?.body.description, "{\n\t(x + 2);\n}\n")
    }

    func testFunctionCall() throws {
        let tests = [
            ("let identity = fn(x) { x; }; identity(5);", 5),
            ("let identity = fn(x) { return x; }; identity(5);", 5),
            ("let double = fn(x) { x * 2; }; double(5);", 10),
            ("let add = fn(x, y) { x + y; }; add(5, 5);", 10),
            ("let add = fn(x, y) { x + y; }; add(5 + 5, add(5, 5));", 20),
            ("fn(x) { x; }(5)", 5)
        ]

        for test in tests {
            let evaluated = try testEval(input: test.0)
            assertInteger(object: evaluated, expected: test.1)
        }
    }

    func testClousure() throws {
        let input = """
        let newAdder = fn(x) {
            fn(y) { x + y };
        };
        let addTwo = newAdder(2);
        addTwo(2);
        """
        let evaluated = try testEval(input: input)
        assertInteger(object: evaluated, expected: 4)
    }

    // MARK: Utils
    func testEval(input: String) throws -> Object? {
        let lexer = MonkeyLexer(withString: input)
        var parser = MonkeyParser(lexer: lexer)

        guard let program = try parser.parseProgram() else {
            return nil
        }
        return try MonkeyEvaluator.eval(program: program, environment: self.environment)
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
