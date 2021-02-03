//
//  ParseLiteralsTests.swift
//  MonkeyTests
//
//  Created by Franklin Cruz on 19-01-21.
//

import XCTest
@testable import Rosetta
@testable import MonkeyLang

class ParseLiteralsTests: XCTestCase {
    func testIntLiteralExpression() throws {
        let input = """
        5;
        100;
        """

        let lexer = MonkeyLexer(withString: input)
        var parser = MonkeyParser(lexer: lexer)

        let program = try parser.parseProgram()
        XCTAssertEqual(program?.statements.count, 2)

        var expressionStmt = program?.statements[0] as? ExpressionStatement
        XCTAssertNotNil(expressionStmt)
        MKAssertIntegerLiteral(expression: expressionStmt?.expression, expected: 5)

        expressionStmt = program?.statements[1] as? ExpressionStatement
        XCTAssertNotNil(expressionStmt)
        MKAssertIntegerLiteral(expression: expressionStmt?.expression, expected: 100)
    }

    func testBooleanLiteralExpression() throws {
        let tests = [
            ("true;", true),
            ("false;", false)
        ]

        for test in tests {
            let lexer = MonkeyLexer(withString: test.0)
            var parser = MonkeyParser(lexer: lexer)

            let program = try parser.parseProgram()
            XCTAssertEqual(program?.statements.count, 1)
            let expressionStmt = program?.statements[0] as? ExpressionStatement
            XCTAssertNotNil(expressionStmt)
            MKAssertBoolLiteral(expression: expressionStmt?.expression, expected: test.1)
        }
    }

    func testStringLiteralExpression() throws {
        let input = """
        "Hello World";
        """

        let lexer = MonkeyLexer(withString: input)
        var parser = MonkeyParser(lexer: lexer)

        let program = try parser.parseProgram()
        XCTAssertEqual(program?.statements.count, 1)

        let expressionStmt = program?.statements[0] as? ExpressionStatement
        XCTAssertNotNil(expressionStmt)
        let string = expressionStmt?.expression as? StringLiteral
        XCTAssertNotNil(string)
        XCTAssertEqual(string?.value, "Hello World")
        XCTAssertEqual(string?.literal, "Hello World")
    }

    func testFunctionLiteral() throws {
        let input = "fn(x, y) { x + y; }"

        let lexer = MonkeyLexer(withString: input)
        var parser = MonkeyParser(lexer: lexer)

        let program = try parser.parseProgram()
        XCTAssertEqual(program?.statements.count, 1)
        let expressionStatement = program?.statements.first as? ExpressionStatement
        let function = expressionStatement?.expression as? FunctionLiteral
        XCTAssertEqual(function?.params.count, 2)
        XCTAssertEqual(function?.params[0].value, "x")
        XCTAssertEqual(function?.params[1].value, "y")
        XCTAssertEqual(function?.body.statements.count, 1)
        let bodyExpression = function?.body.statements.first as? ExpressionStatement
        MKAssertInfixExpression(expression: bodyExpression?.expression, lhs: "x", operatorSymbol: "+", rhs: "y")
    }

    func testArrayLiteral() throws {
        var input = "[1, 2 * 2, 3 + 3]"
        var lexer = MonkeyLexer(withString: input)
        var parser = MonkeyParser(lexer: lexer)

        var program = try parser.parseProgram()
        XCTAssertEqual(program?.statements.count, 1)

        var expressionStatement = program?.statements.first as? ExpressionStatement
        var array = expressionStatement?.expression as? ArrayLiteral
        XCTAssertNotNil(array)
        XCTAssertEqual(array?.elements.count, 3)

        MKAssertIntegerLiteral(expression: array?.elements[0], expected: 1)
        MKAssertInfixExpression(expression: array?.elements[1], lhs: "2", operatorSymbol: "*", rhs: "2")
        MKAssertInfixExpression(expression: array?.elements[2], lhs: "3", operatorSymbol: "+", rhs: "3")

        input = "[]"
        lexer = MonkeyLexer(withString: input)
        parser = MonkeyParser(lexer: lexer)

        program = try parser.parseProgram()
        XCTAssertEqual(program?.statements.count, 1)

        expressionStatement = program?.statements.first as? ExpressionStatement
        array = expressionStatement?.expression as? ArrayLiteral
        XCTAssertNotNil(array)
        XCTAssertEqual(array?.elements.count, 0)
    }
}
