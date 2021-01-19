//
//  LexerTypesTests.swift
//  MonkeyTests
//
//  Created by Franklin Cruz on 19-01-21.
//

import XCTest
@testable import Rosetta
@testable import MonkeyLang

class LexerTypesTests: XCTestCase {
    func testStrings() throws {
        let input = #"""
        "foobar"
        "foo bar"
        "foo \"bar\""
        "foo\n\"bar\""
        "foo\\\n\"bar\""
        "\tfoo\\\n\"bar\""
        """#
        let expect = [
            Token(type: .string, literal: "foobar"),
            Token(type: .string, literal: "foo bar"),
            Token(type: .string, literal: "foo \"bar\""),
            Token(type: .string, literal: "foo\n\"bar\""),
            Token(type: .string, literal: "foo\\\n\"bar\""),
            Token(type: .string, literal: "\tfoo\\\n\"bar\"")
        ]
        var lexer = MonkeyLexer(withString: input)
        for token in expect {
            let next = lexer.nextToken()
            XCTAssertEqual(next, token)
        }
    }

    func testInvalidStrings() throws {
        let tests = [
            ("\"foo\nbar", Token(type: .ilegal, literal: "\n")),
            ("\"foo\\\"\nbar", Token(type: .ilegal, literal: "\n")),
            ("\"\\hfoo\"\nbar", Token(type: .ilegal, literal: "h"))
        ]

        for test in tests {
            var lexer = MonkeyLexer(withString: test.0)
            let next = lexer.nextToken()
            XCTAssertEqual(next, test.1)
        }
    }

    func testReadIdentifier() throws {
        var input = "myIdentifier"
        var lexer = MonkeyLexer(withString: input)
        XCTAssertEqual(lexer.readIdentifier(), input)

        input = "with_underscore"
        lexer = MonkeyLexer(withString: input)
        XCTAssertEqual(lexer.readIdentifier(), input)

        input = "with spaces"
        lexer = MonkeyLexer(withString: input)
        XCTAssertEqual(lexer.readIdentifier(), "with")
        XCTAssertEqual(lexer.currentColumn, 4)

        input = "#nothing"
        lexer = MonkeyLexer(withString: input)
        XCTAssertEqual(lexer.readIdentifier(), "")
        XCTAssertEqual(lexer.currentColumn, 0)

        input = "a single letter"
        lexer = MonkeyLexer(withString: input)
        XCTAssertEqual(lexer.readIdentifier(), "a")
        XCTAssertEqual(lexer.currentColumn, 1)
    }

    func testReadInteger() throws {
        var input = "555"
        var lexer = MonkeyLexer(withString: input)
        XCTAssertEqual(lexer.readNumber(), input)

        input = "22 22"
        lexer = MonkeyLexer(withString: input)
        XCTAssertEqual(lexer.readNumber(), "22")

        input = "#22 22"
        lexer = MonkeyLexer(withString: input)
        XCTAssertEqual(lexer.readNumber(), "")
        XCTAssertEqual(lexer.currentColumn, 0)

        input = "42 22"
        lexer = MonkeyLexer(withString: input)
        XCTAssertEqual(lexer.readNumber(), "42")
        XCTAssertEqual(lexer.currentColumn, 2)

        input = "1"
        lexer = MonkeyLexer(withString: input)
        XCTAssertEqual(lexer.readNumber(), "1")
    }
}
