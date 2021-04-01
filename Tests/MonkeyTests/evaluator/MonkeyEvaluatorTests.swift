//
//  MonkeyEvaluatorTests.swift
//  HermesTest
//
//  Created by Franklin Cruz on 07-01-21.
//

import XCTest
@testable import Hermes
@testable import MonkeyLang

// swiftlint:disable type_body_length
class MonkeyEvaluatorTests: XCTestCase {
    func testEvalComments() throws {
        let input = """
        var x = 100; // Inline
        // Fullline
        // with code x = 200;
        /*multi*/
        x * 10; /*and here*/
        // 200;
        /* with code:
        42;
        */
        """
        let evaluated = try Utils.testEval(input: input, environment: Environment())
        XCTAssertNotNil(evaluated)
        MKAssertInteger(object: evaluated, expected: 1000)
    }

    func testEvalStrings() throws {
        let input = "\"Hello World!\""
        let evaluated = try Utils.testEval(input: input, environment: Environment())
        let string = evaluated as? MString
        XCTAssertNotNil(string)
        XCTAssertEqual(string?.value, "Hello World!")
        XCTAssertEqual(string?.description, "Hello World!")
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
            let evaluated = try Utils.testEval(input: test.0, environment: Environment())
            if let expected = test.1 {
                MKAssertInteger(object: evaluated, expected: expected)
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
            let evaluated = try Utils.testEval(input: test.0, environment: Environment())
            MKAssertInteger(object: evaluated, expected: test.1)
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
            ("foobar", "\"foobar\" is not defined at Line: 1, Column: 0"),
            (#""Hello" - "World";"#, "Can't apply operator \"-\" to String and String at Line: 1, Column: 8"),
            (#"{"name": "Monkey"}[fn(x) { x }];"#, "Can't use type: function as Hash Key at Line: 1, Column: 18")
        ]

        for test in tests {
            do {
                _ = try Utils.testEval(input: test.0, environment: Environment())
            } catch let error as EvaluatorError {
                XCTAssertEqual(error.description, test.1)
            }
        }
    }

    func testDeclareStatement() throws {
        let tests = [
            ("let a = 5; a;", 5),
            ("let a = 5 * 5; a;", 25),
            ("let a = 5; let b = a; b;", 5),
            ("let a = 5; let b = a; let c = a + b + 5; c;", 15),
            ("let a = 5; let a = 10; a;", nil),
            ("var a = 5; a;", 5),
            ("var a = 5 * 5; a;", 25),
            ("var a = 5; let b = a; b;", 5),
            ("var a = 5; let b = a; let c = a + b + 5; c;", 15),
            ("var a = 5; var a = 10; a;", nil)
        ]

        for test in tests {
            do {
                let evaluated = try Utils.testEval(input: test.0, environment: Environment())
                if let expected = test.1 {
                    MKAssertInteger(object: evaluated, expected: expected)
                } else {
                    XCTFail("Expected and error")
                }
            } catch let error as RedeclarationError {
                XCTAssertNil(test.1)
                XCTAssertEqual(error.description, "Cannot redeclare: \"a\" it already exists at Line: 1, Column: 11")
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }

    func testAssignStatement() throws {
        let tests = [
            ("var a = 5; a = 10; a;", 10),
            ("var a = 10; a = 5 * 5; a;", 25),
            ("var a = 5; let b = 10; a = b; a;", 10),
            ("var a = 5; let b = a; a = a + b + 5; a;", 15),
            ("let a = 5; a = 10; a;", nil),
            ("var a = 5; a = true; a;", nil)
        ]

        for test in tests {
            do {
                let evaluated = try Utils.testEval(input: test.0, environment: Environment())
                if let expected = test.1 {
                    MKAssertInteger(object: evaluated, expected: expected)
                } else {
                    XCTFail("Expected and error")
                }
            } catch let error as AssignConstantError {
                XCTAssertNil(test.1)
                XCTAssertEqual(error.description, "Cannot assign to value: \"a\" is a constant at Line: 1, Column: 11")
            } catch let error as TypeError {
                XCTAssertNil(test.1)
                XCTAssertEqual(
                    error.description,
                    "Can't assign value of type: Boolean to variable of type: Integer at Line: 1, Column: 11"
                )
            } catch {
                XCTFail("Unexpected error")
            }
        }
    }

    func testFunctionObject() throws {
        let input = "fn(x) { x + 2; };"
        let evaluated = try Utils.testEval(input: input, environment: Environment())
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
            let evaluated = try Utils.testEval(input: test.0, environment: Environment())
            MKAssertInteger(object: evaluated, expected: test.1)
        }
    }

    func testClousure() throws {
        let input = """
        let a = 10;
        let newAdder = fn(x) {
            let a = 20;
            return fn(y) { x + y };
        };
        let addTwo = newAdder(2);
        addTwo(2);
        """
        let evaluated = try Utils.testEval(input: input, environment: Environment())
        MKAssertInteger(object: evaluated, expected: 4)
    }

    func testArrayLiteral() throws {
        let input = "[1, 2 * 2, 3 + 3]"
        let evaluated = try Utils.testEval(input: input, environment: Environment())
        let array = evaluated as? MArray
        XCTAssertNotNil(array)
        XCTAssertEqual(array?.elements.count, 3)
        MKAssertInteger(object: array?.elements[0], expected: 1)
        MKAssertInteger(object: array?.elements[1], expected: 4)
        MKAssertInteger(object: array?.elements[2], expected: 6)
    }

    func testArrayIndexExpression() throws {
        let tests = [
            ("[1, 2, 3][0]", 1),
            ("[1, 2, 3][1]", 2),
            ("[1, 2, 3][2]", 3),
            ("let i = 0; [1][i];", 1),
            ("[1, 2, 3][1 + 1]", 3),
            ("let myArray = [1, 2, 3]; myArray[2];", 3),
            ("let myArray = [1, 2, 3]; myArray[0] + myArray[1] + myArray[2];", 6),
            ("let myArray = [1, 2, 3]; let i = myArray[0]; myArray[i]", 2),
            ("[1, 2, 3][3]", nil),
            ("[1, 2, 3][-1]", nil)
        ]

        for test in tests {
            let evaluated = try Utils.testEval(input: test.0, environment: Environment())
            if let expected = test.1 {
                MKAssertInteger(object: evaluated, expected: expected)
            } else {
                XCTAssert((evaluated == Null.null).value)
            }
        }
    }

    func testHashIndexExpressions() throws {
        let tests = [
            (#"{"foo": 5}["foo"]"#, 5),
            (#"{"foo": 5}["bar"]"#, nil),
            (#"let key = "foo"; {"foo": 5}[key]"#, 5),
            (#"{}["foo"]"#, nil),
            (#"{5: 5}[5]"#, 5),
            (#"{true: 5}[true]"#, 5),
            (#"{false: 5}[false]"#, 5)
        ]

        for test in tests {
            let evaluated = try Utils.testEval(input: test.0, environment: Environment())
            if let expected = test.1 {
                MKAssertInteger(object: evaluated, expected: expected)
            } else {
                XCTAssert((evaluated == Null.null).value)
            }
        }
    }

    func testHashLiteral() throws {
        let input = """
        let two = "two";
        {
            "one": 10 - 9,
            "two": 1 + 1,
            "thr" + "ee": 6 / 2,
            4: 4,
            true: 5,
            false: 6
        }
        """
        let evaluated = try Utils.testEval(input: input, environment: Environment())
        let hash = evaluated as? Hash
        XCTAssertNotNil(hash)

        let expected: [(Any, Int, String)] = [
            ("one", 1, "string"),
            ("two", 2, "string"),
            ("three", 3, "string"),
            (4, 4, "integer"),
            (true, 5, "boolean"),
            (false, 6, "boolean")
        ]

        for expect in expected {
            switch expect.2 {
            case "string":
                let value = hash?.pairs[MString(expect.0 as? String ?? "")]
                MKAssertInteger(object: value, expected: expect.1)
            case "integer":
                let value = hash?.pairs[Integer(expect.0 as? Int ?? -1)]
                MKAssertInteger(object: value, expected: expect.1)
            case "boolean":
                let value = hash?.pairs[Boolean(expect.0 as? Bool ?? false)]
                MKAssertInteger(object: value, expected: expect.1)
            default:
                XCTFail("Never will happen")
            }
        }
    }
}
