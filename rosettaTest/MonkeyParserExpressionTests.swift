//
//  MonkeyParserTests.swift
//  rosettaTest
//
//  Created by Franklin Cruz on 01-01-21.
//

import XCTest

class MonkeyParserExpressionTests: XCTestCase {
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
            ("!(true == true)", "(!(true == true))\n"),
            ("a + add(b * c) + d", "((a + add((b * c))) + d)\n"),
            ("add(a, b, 1, 2 * 3, 4 + 5, add(6, 7 * 8))", "add(a, b, 1, (2 * 3), (4 + 5), add(6, (7 * 8)))\n"),
            ("add(a + b + c * d / f + g)", "add((((a + b) + ((c * d) / f)) + g))\n")
        ]

        for test in tests {
            let lexer = MonkeyLexer(withString: test.0)
            var parser = MonkeyParser(lexer: lexer)

            let program = try parser.parseProgram()
            XCTAssertNotNil(program)
            XCTAssertEqual(program?.description, test.1)
        }
    }

    func testIfExpression() throws {
        let input = "if (x < y) { x }"

        let lexer = MonkeyLexer(withString: input)
        var parser = MonkeyParser(lexer: lexer)

        let program = try parser.parseProgram()
        XCTAssertNotNil(program)
        XCTAssertEqual(program?.statements.count, 1)
        let expressionStatement = program?.statements.first as? ExpressionStatement
        let ifExpression = expressionStatement?.expression as? IfExpression
        XCTAssertNotNil(ifExpression)
        assertInfixExpression(expression: ifExpression?.condition, lhs: "x", operatorSymbol: "<", rhs: "y")

        XCTAssertEqual(ifExpression?.consequence.statements.count, 1)
        XCTAssertNotNil(ifExpression?.consequence.statements.first)
        let consequence = ifExpression?.consequence.statements.first as? ExpressionStatement
        assertIdentifier(expression: consequence?.expression, expected: "x")

        XCTAssertNil(ifExpression?.alternative)
    }

    func testIfElseExpression() throws {
        let input = "if (x < y) { x } else { y }"

        let lexer = MonkeyLexer(withString: input)
        var parser = MonkeyParser(lexer: lexer)

        let program = try parser.parseProgram()
        XCTAssertNotNil(program)
        XCTAssertEqual(program?.statements.count, 1)
        let expressionStatement = program?.statements.first as? ExpressionStatement
        let ifExpression = expressionStatement?.expression as? IfExpression
        XCTAssertNotNil(ifExpression)
        assertInfixExpression(expression: ifExpression?.condition, lhs: "x", operatorSymbol: "<", rhs: "y")

        XCTAssertEqual(ifExpression?.consequence.statements.count, 1)
        XCTAssertNotNil(ifExpression?.consequence.statements.first)
        let consequence = ifExpression?.consequence.statements.first as? ExpressionStatement
        assertIdentifier(expression: consequence?.expression, expected: "x")

        XCTAssertNotNil(ifExpression?.alternative)
        let alternative = ifExpression?.alternative?.statements.first as? ExpressionStatement
        assertIdentifier(expression: alternative?.expression, expected: "y")
    }

    func testFunctionLiteral() throws {
        let input = "fn(x, y) { x + y; }"

        let lexer = MonkeyLexer(withString: input)
        var parser = MonkeyParser(lexer: lexer)

        let program = try parser.parseProgram()
        XCTAssertNotNil(program)
        XCTAssertEqual(program?.statements.count, 1)
        let expressionStatement = program?.statements.first as? ExpressionStatement
        let function = expressionStatement?.expression as? FuctionLiteral
        XCTAssertEqual(function?.params.count, 2)
        XCTAssertEqual(function?.params[0].value, "x")
        XCTAssertEqual(function?.params[1].value, "y")
        XCTAssertEqual(function?.body.statements.count, 1)
        let bodyExpression = function?.body.statements.first as? ExpressionStatement
        assertInfixExpression(expression: bodyExpression?.expression, lhs: "x", operatorSymbol: "+", rhs: "y")
    }

    func testCallExpression() throws {
        let input = "add(1, 2 * 3, 4 + 5)"

        let lexer = MonkeyLexer(withString: input)
        var parser = MonkeyParser(lexer: lexer)

        let program = try parser.parseProgram()
        XCTAssertNotNil(program)
        XCTAssertEqual(program?.statements.count, 1)

        let expressionStatement = program?.statements.first as? ExpressionStatement
        let call = expressionStatement?.expression as? CallExpression

        assertIdentifier(expression: call?.function, expected: "add")
        assertIntegerLiteral(expression: call?.args[0], expected: 1)
        assertInfixExpression(expression: call?.args[1], lhs: "2", operatorSymbol: "*", rhs: "3")
        assertInfixExpression(expression: call?.args[2], lhs: "4", operatorSymbol: "+", rhs: "5")
    }

    // MARK: Utils
    func assertInfixExpression(expression: Expression?, lhs: String, operatorSymbol: String, rhs: String) {
        let infix = expression as? InfixExpression
        XCTAssertNotNil(infix)
        XCTAssertEqual(infix?.lhs.literal, lhs)
        XCTAssertEqual(infix?.operatorSymbol, operatorSymbol)
        XCTAssertEqual(infix?.rhs.literal, rhs)
    }

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
