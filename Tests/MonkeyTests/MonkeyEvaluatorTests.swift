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

    func testEvalStringConcatention() throws {
        let tests = [
            (#""Hello" + " " + "World!""#, "Hello World!"),
            (#""Hello " + 10"#, "Hello 10"),
            (#""Hello " + true"#, "Hello true"),
            (#"10 + " Hello""#, "10 Hello"),
            (#"true + " Hello""#, "true Hello")
        ]

        for test in tests {
            let evaluated = try testEval(input: test.0)
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
            (#""Hello" == true"#, true),
            ("\"\" == false", true)
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
            (#""Hello" - "World";"#, "Can't apply operator \"-\" to String and String at Line: 1, Column: 8")
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

    func testLenFunction() throws {
        let tests: [(String, Any)] = [
            ("len(\"\")", 0),
            ("len(\"four\")", 4),
            ("len(\"Hello World\")", 11),
            ("len([1, 2])", 2),
            ("len([])", 0),
            ("len(1)", "Incorrect argment type expected: String or Array got: Integer at Line: 1, Column: 3"),
            (
                "len(\"one\", \"two\")",
                "Incorrect number of arguments in function call expected: 1 but got: 2 at Line: 1, Column: 3"
            )
        ]

        for test in tests {
            do {
                let evaluated = try testEval(input: test.0)
                assertInteger(object: evaluated, expected: test.1 as? Int ?? -1)
            } catch let error as WrongArgumentCount {
                XCTAssertEqual(error.description, test.1 as? String ?? "")
            } catch let error as InvalidArgumentType {
                XCTAssertEqual(error.description, test.1 as? String ?? "")
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }

    func testFirstFunction() throws {
        let tests: [(String, Any?)] = [
            ("first([1, 2])", 1),
            ("first([])", nil),
            ("first(1)", "Incorrect argment type expected: Array got: Integer at Line: 1, Column: 5"),
            (
                "first(\"one\", \"two\")",
                "Incorrect number of arguments in function call expected: 1 but got: 2 at Line: 1, Column: 5"
            )
        ]

        for test in tests {
            do {
                let evaluated = try testEval(input: test.0)
                if let expected = test.1 as? Int {
                    assertInteger(object: evaluated, expected: expected)
                } else {
                    XCTAssert((evaluated == Null.null).value)
                }
            } catch let error as WrongArgumentCount {
                XCTAssertEqual(error.description, test.1 as? String ?? "")
            } catch let error as InvalidArgumentType {
                XCTAssertEqual(error.description, test.1 as? String ?? "")
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }

    func testLastFunction() throws {
        let tests: [(String, Any?)] = [
            ("last([1, 2])", 2),
            ("last([])", nil),
            ("last(1)", "Incorrect argment type expected: Array got: Integer at Line: 1, Column: 4"),
            (
                "last(\"one\", \"two\")",
                "Incorrect number of arguments in function call expected: 1 but got: 2 at Line: 1, Column: 4"
            )
        ]

        for test in tests {
            do {
                let evaluated = try testEval(input: test.0)
                if let expected = test.1 as? Int {
                    assertInteger(object: evaluated, expected: expected)
                } else {
                    XCTAssert((evaluated == Null.null).value)
                }
            } catch let error as WrongArgumentCount {
                XCTAssertEqual(error.description, test.1 as? String ?? "")
            } catch let error as InvalidArgumentType {
                XCTAssertEqual(error.description, test.1 as? String ?? "")
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }

    func testPushFunction() throws {
        let tests: [(String, Any?)] = [
            ("push([1, 2], 3)", 3),
            ("push([], 1)", 1),
            ("push(1, 1)", "Incorrect argment type expected: Array got: Integer at Line: 1, Column: 4"),
            (
                "push([])",
                "Incorrect number of arguments in function call expected: 2 but got: 1 at Line: 1, Column: 4"
            )
        ]

        for test in tests {
            do {
                let evaluated = try testEval(input: test.0) as? MArray
                if let expected = test.1 as? Int {
                    XCTAssertEqual(evaluated?.elements.count, expected)
                } else {
                    XCTAssert((evaluated == Null.null).value)
                }
            } catch let error as WrongArgumentCount {
                XCTAssertEqual(error.description, test.1 as? String ?? "")
            } catch let error as InvalidArgumentType {
                XCTAssertEqual(error.description, test.1 as? String ?? "")
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }

    func testRestFunction() throws {
        let tests: [(String, Any?)] = [
            ("rest([1, 2])", 1),
            ("rest([1])", 0),
            ("rest([])", nil),
            ("rest(1)", "Incorrect argment type expected: Array got: Integer at Line: 1, Column: 4"),
            (
                "rest(1, 2)",
                "Incorrect number of arguments in function call expected: 1 but got: 2 at Line: 1, Column: 4"
            )
        ]

        for test in tests {
            do {
                let evaluated = try testEval(input: test.0)
                if let expected = test.1 as? Int {
                    let array = evaluated as? MArray
                    XCTAssertEqual(array?.elements.count, expected)
                } else {
                    XCTAssert((evaluated == Null.null).value)
                }
            } catch let error as WrongArgumentCount {
                XCTAssertEqual(error.description, test.1 as? String ?? "")
            } catch let error as InvalidArgumentType {
                XCTAssertEqual(error.description, test.1 as? String ?? "")
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }

    func testArrayLiteral() throws {
        let input = "[1, 2 * 2, 3 + 3]"
        let evaluated = try testEval(input: input)
        let array = evaluated as? MArray
        XCTAssertNotNil(array)
        XCTAssertEqual(array?.elements.count, 3)
        assertInteger(object: array?.elements[0], expected: 1)
        assertInteger(object: array?.elements[1], expected: 4)
        assertInteger(object: array?.elements[2], expected: 6)
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
            let evaluated = try testEval(input: test.0)
            if let expected = test.1 {
                assertInteger(object: evaluated, expected: expected)
            } else {
                XCTAssert((evaluated == Null.null).value)
            }
        }
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
