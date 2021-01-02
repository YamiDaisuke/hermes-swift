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
        let identifier = expressionStmt?.expression as? Identifier
        XCTAssertNotNil(identifier)
        XCTAssertEqual(identifier?.value, "foobar")
        XCTAssertEqual(identifier?.literal, "foobar")
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
        var identifier = expressionStmt?.expression as? IntegerLiteral
        XCTAssertNotNil(identifier)
        XCTAssertEqual(identifier?.value, 5)
        XCTAssertEqual(identifier?.literal, "5")

        expressionStmt = program?.statements[1] as? ExpressionStatement
        XCTAssertNotNil(expressionStmt)
        identifier = expressionStmt?.expression as? IntegerLiteral
        XCTAssertNotNil(identifier)
        XCTAssertEqual(identifier?.value, 100)
        XCTAssertEqual(identifier?.literal, "100")
    }
}
