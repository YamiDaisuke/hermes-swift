//
//  MonkeyParserTests.swift
//  rosettaTest
//
//  Created by Franklin Cruz on 01-01-21.
//

import XCTest

class MonkeyParserTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testParseLetStatementErrors() throws {
        let input = """
        let 5;
        let y 10;
        """
        let lexer = MonkeyLexer(withString: input)
        var parser = MonkeyParser(lexer: lexer)

        do {
            _ = try parser.parseProgram()
        } catch let error as AllParserError {
            XCTAssertEqual(error.errors.count, 2)
            XCTAssert(error.errors[0] is MissingExpected)
            XCTAssertEqual(error.errors[0].message, "Expected token identifier")

            XCTAssert(error.errors[1] is MissingExpected)
            XCTAssertEqual(error.errors[1].message, "Expected token =")
        }
    }

    func testParseLetStatement() throws {
        let input = """
        let x = 5;
        let y = 10;
        let foobar = 434342;
        """
        let lexer = MonkeyLexer(withString: input)
        var parser = MonkeyParser(lexer: lexer)

        let program = try parser.parseProgram()
        XCTAssertNotNil(program)
        XCTAssertEqual(program?.statements.count, 3)

        let expectedIdentifier = [ "x", "y", "foobar"]
        for index in 0..<expectedIdentifier.count {
            let statement = program!.statements[index]
            XCTAssertEqual(statement.literal, "let")
            let letStatement = statement as? LetStatement
            XCTAssertNotNil(letStatement)
            XCTAssertEqual(letStatement?.name.value, expectedIdentifier[index])
            XCTAssertEqual(letStatement?.name.literal, expectedIdentifier[index])
        }
    }

    func testReturnStatement() throws {
        let input = """
        return 5;
        return 10;
        return 99994343;
        """
        let lexer = MonkeyLexer(withString: input)
        var parser = MonkeyParser(lexer: lexer)

        let program = try parser.parseProgram()
        XCTAssertNotNil(program)
        XCTAssertEqual(program?.statements.count, 3)

        for statement in program!.statements {
            let returnStatement = statement as? ReturnStatement
            XCTAssertNotNil(returnStatement)
        }
    }

    // MARK: Expressions

    func testIdentifierExpression() throws {
        let input = """
        foobar;
        """

        let lexer = MonkeyLexer(withString: input)
        var parser = MonkeyParser(lexer: lexer)

        let program = try parser.parseProgram()
        XCTAssertNotNil(program)
        XCTAssertEqual(program?.statements.count, 1)

        let expressionStmt = program?.statements.first as? ExpressionStatement
        XCTAssertNotNil(expressionStmt)
        assertIdentifier(expression: expressionStmt?.expression, expected: "foobar")
    }

    func testIntLiteralExpression() throws {
        let input = """
        5;
        100;
        """

        let lexer = MonkeyLexer(withString: input)
        var parser = MonkeyParser(lexer: lexer)

        let program = try parser.parseProgram()
        XCTAssertNotNil(program)
        XCTAssertEqual(program?.statements.count, 2)

        var expressionStmt = program?.statements[0] as? ExpressionStatement
        XCTAssertNotNil(expressionStmt)
        assertIntegerLiteral(expression: expressionStmt?.expression, expected: 5)

        expressionStmt = program?.statements[1] as? ExpressionStatement
        XCTAssertNotNil(expressionStmt)
        assertIntegerLiteral(expression: expressionStmt?.expression, expected: 100)
    }

    func testBooleanExpression() throws {
        let input = """
        true;
        false;
        """

        let lexer = MonkeyLexer(withString: input)
        var parser = MonkeyParser(lexer: lexer)

        let program = try parser.parseProgram()
        XCTAssertNotNil(program)
        XCTAssertEqual(program?.statements.count, 2)

        var expressionStmt = program?.statements[0] as? ExpressionStatement
        XCTAssertNotNil(expressionStmt)
        assertBoolLiteral(expression: expressionStmt?.expression, expected: true)

        expressionStmt = program?.statements[1] as? ExpressionStatement
        XCTAssertNotNil(expressionStmt)
        assertBoolLiteral(expression: expressionStmt?.expression, expected: false)
    }

    func testPrefixExpressions() throws {
        let tests: [(input: String, operator: String, value: Any)] = [
            (input: "!5;", operator: "!", value: 5),
            (input: "-15;", operator: "-", value: 15),
            (input: "!true;", operator: "!", value: true),
            (input: "!false;", operator: "!", value: false)
        ]

        for test in tests {
            let lexer = MonkeyLexer(withString: test.input)
            var parser = MonkeyParser(lexer: lexer)

            let program = try parser.parseProgram()
            XCTAssertNotNil(program)
            XCTAssertEqual(program?.statements.count, 1)

            let expressionStmt = program?.statements[0] as? ExpressionStatement
            XCTAssertNotNil(expressionStmt)

            let prefix = expressionStmt?.expression as? PrefixExpression
            XCTAssertNotNil(prefix)
            XCTAssertEqual(prefix?.operatorSymbol, test.operator)

            if let intValue = test.value as? Int {
                assertIntegerLiteral(expression: prefix?.rhs, expected: intValue)
            }

            if let boolValue = test.value as? Bool {
                assertBoolLiteral(expression: prefix?.rhs, expected: boolValue)
            }

        }
    }

    func testInfixExpressions() throws {
        let tests: [(input: String, lhs: Any, operator: String, rhs: Any)] = [
            (input: "5 + 5;", lhs: 5, operator: "+", rhs: 5),
            (input: "5 - 5;", lhs: 5, operator: "-", rhs: 5),
            (input: "5 * 5;", lhs: 5, operator: "*", rhs: 5),
            (input: "5 / 5;", lhs: 5, operator: "/", rhs: 5),
            (input: "5 > 5;", lhs: 5, operator: ">", rhs: 5),
            (input: "5 < 5;", lhs: 5, operator: "<", rhs: 5),
            (input: "5 == 5;", lhs: 5, operator: "==", rhs: 5),
            (input: "5 != 5;", lhs: 5, operator: "!=", rhs: 5),
            (input: "true == true;", lhs: true, operator: "==", rhs: true),
            (input: "true != false;", lhs: true, operator: "!=", rhs: false),
            (input: "false == false;", lhs: false, operator: "==", rhs: false)
        ]

        for test in tests {
            let lexer = MonkeyLexer(withString: test.input)
            var parser = MonkeyParser(lexer: lexer)

            let program = try parser.parseProgram()
            XCTAssertNotNil(program)
            XCTAssertEqual(program?.statements.count, 1)

            let expressionStmt = program?.statements[0] as? ExpressionStatement
            XCTAssertNotNil(expressionStmt)

            let infix = expressionStmt?.expression as? InfixExpression
            XCTAssertNotNil(infix)
            XCTAssertEqual(infix?.operatorSymbol, test.operator)

            if let intValue = test.lhs as? Int {
                assertIntegerLiteral(expression: infix?.lhs, expected: intValue)
            }

            if let intValue = test.rhs as? Int {
                assertIntegerLiteral(expression: infix?.rhs, expected: intValue)
            }

            if let boolValue = test.lhs as? Bool {
                assertBoolLiteral(expression: infix?.lhs, expected: boolValue)
            }

            if let boolValue = test.rhs as? Bool {
                assertBoolLiteral(expression: infix?.rhs, expected: boolValue)
            }
        }
    }

    func testExpressions() throws {
        let tests = [
            ("-a * b", "((-a) * b)\n"),
            ("!-a", "(!(-a))\n"),
            ("a + b - c", "((a + b) - c)\n"),
            ("a * b * c", "((a * b) * c)\n"),
            ("a * b / c", "((a * b) / c)\n"),
            ("a + b * c + d / e - f", "(((a + (b * c)) + (d / e)) - f)\n"),
            ("3 + 4; -5 * 5", "(3 + 4)\n((-5) * 5)\n"),
            ("5 > 4 == 3 < 4", "((5 > 4) == (3 < 4))\n"),
            ("5 < 4 != 3 > 4", "((5 < 4) != (3 > 4))\n"),
            ("3 + 4 * 5 == 3 * 1 + 4 * 5", "((3 + (4 * 5)) == ((3 * 1) + (4 * 5)))\n"),
            ("3 + 4 * 5 == 3 * 1 + 4 * 5", "((3 + (4 * 5)) == ((3 * 1) + (4 * 5)))\n"),
            ("true", "true\n"),
            ("false", "false\n"),
            ("3 > 5 == false", "((3 > 5) == false)\n"),
            ("3 > 5 == true", "((3 > 5) == true)\n"),
            ("1 + (2 + 3) + 4", "((1 + (2 + 3)) + 4)\n"),
            ("(5 + 5) * 2", "((5 + 5) * 2)\n"),
            ("2 / (5 + 5)", "(2 / (5 + 5))\n"),
            ("-(5 + 5)", "(-(5 + 5))\n"),
            ("!(true == true)", "(!(true == true))\n")
        ]

        for test in tests {
            let lexer = MonkeyLexer(withString: test.0)
            var parser = MonkeyParser(lexer: lexer)

            let program = try parser.parseProgram()
            XCTAssertNotNil(program)
            XCTAssertEqual(program?.description, test.1)
        }
    }

    // MARK: Utils

    func assertIntegerLiteral(expression: Expression?, expected: Int) {
        let integer = expression as? IntegerLiteral
        XCTAssertNotNil(integer)
        XCTAssertEqual(integer?.value, expected)
        XCTAssertEqual(integer?.literal, expected.description)
    }

    func assertBoolLiteral(expression: Expression?, expected: Bool) {
        let boolean = expression as? BooleanLiteral
        XCTAssertNotNil(boolean)
        XCTAssertEqual(boolean?.value, expected)
        XCTAssertEqual(boolean?.literal, expected.description)
    }

    func assertIdentifier(expression: Expression?, expected: String) {
        let identifier = expression as? Identifier
        XCTAssertNotNil(identifier)
        XCTAssertEqual(identifier?.value, expected)
        XCTAssertEqual(identifier?.literal, expected)
    }
}
