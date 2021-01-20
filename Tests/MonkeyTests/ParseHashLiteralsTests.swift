//
//  ParseHashLiteralsTests.swift
//  MonkeyTests
//
//  Created by Franklin Cruz on 20-01-21.
//

import XCTest
@testable import Rosetta
@testable import MonkeyLang

class ParseHashLiteralsTests: XCTestCase {
    func testParsingEmptyHashLiteral() throws {
        let input = #"{"one" : 1, "two": 2, "three": 3}"#
        let lexer = MonkeyLexer(withString: input)
        var parser = MonkeyParser(lexer: lexer)

        let program = try parser.parseProgram()
        XCTAssertEqual(program?.statements.count, 1)

        let expressionStatement = program?.statements.first as? ExpressionStatement
        let hash = expressionStatement?.expression as? HashLiteral
        XCTAssertNotNil(hash)
        XCTAssertEqual(hash?.pairs.count, 3)

        let expected = [
            ("one", "1"),
            ("two", "2"),
            ("three", "3")
        ]

        for index in 0..<expected.count {
            XCTAssertEqual(hash?.pairs[index].key.literal, expected[index].0)
            XCTAssertEqual(hash?.pairs[index].value.literal, expected[index].1)
        }
    }

    func testParsingHashLiteralWithStringKeys() throws {
        let input = #"{"one" : 1, "two": 2, "three": 3}"#
        let lexer = MonkeyLexer(withString: input)
        var parser = MonkeyParser(lexer: lexer)

        let program = try parser.parseProgram()
        XCTAssertEqual(program?.statements.count, 1)

        let expressionStatement = program?.statements.first as? ExpressionStatement
        let hash = expressionStatement?.expression as? HashLiteral
        XCTAssertNotNil(hash)
        XCTAssertEqual(hash?.pairs.count, 3)

        let expected = [
            ("one", "1"),
            ("two", "2"),
            ("three", "3")
        ]

        for index in 0..<expected.count {
            XCTAssertEqual(hash?.pairs[index].key.literal, expected[index].0)
            XCTAssertEqual(hash?.pairs[index].value.literal, expected[index].1)
        }
    }

    func testParsingHashLiteralWithIntegerKeys() throws {
        let input = #"{1 : 1, 2: 2, 33: 33}"#
        let lexer = MonkeyLexer(withString: input)
        var parser = MonkeyParser(lexer: lexer)

        let program = try parser.parseProgram()
        XCTAssertEqual(program?.statements.count, 1)

        let expressionStatement = program?.statements.first as? ExpressionStatement
        let hash = expressionStatement?.expression as? HashLiteral
        XCTAssertNotNil(hash)
        XCTAssertEqual(hash?.pairs.count, 3)

        let expected = [
            ("1", "1"),
            ("2", "2"),
            ("33", "33")
        ]

        for index in 0..<expected.count {
            XCTAssert(hash?.pairs[index].key is IntegerLiteral)
            XCTAssertEqual(hash?.pairs[index].key.literal, expected[index].0)
            XCTAssertEqual(hash?.pairs[index].value.literal, expected[index].1)
        }
    }

    func testParsingHashLiteralWithBooleanKeys() throws {
        let input = #"{true : 1, false: 2}"#
        let lexer = MonkeyLexer(withString: input)
        var parser = MonkeyParser(lexer: lexer)

        let program = try parser.parseProgram()
        XCTAssertEqual(program?.statements.count, 1)

        let expressionStatement = program?.statements.first as? ExpressionStatement
        let hash = expressionStatement?.expression as? HashLiteral
        XCTAssertNotNil(hash)
        XCTAssertEqual(hash?.pairs.count, 2)

        let expected = [
            ("true", "1"),
            ("false", "2")
        ]

        for index in 0..<expected.count {
            XCTAssert(hash?.pairs[index].key is BooleanLiteral)
            XCTAssertEqual(hash?.pairs[index].key.literal, expected[index].0)
            XCTAssertEqual(hash?.pairs[index].value.literal, expected[index].1)
        }
    }
}
