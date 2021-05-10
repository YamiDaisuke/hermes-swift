//
//  MonkeyLexerTests.swift
//  HermesTest
//
//  Created by Franklin Cruz on 31-12-20.
//

import XCTest
@testable import Hermes
@testable import MonkeyLang

// swiftlint:disable function_body_length
// swiftlint:disable type_body_length
class MonkeyLexerTests: XCTestCase {
    func testNextToken() throws {
        // swiftlint:disable indentation_width
        let input = """
        let five = 5;
        let ten = 10;

        let add = fn(x, y) {
             x + y;
        };

        let result = add(five, ten);
        ! - / * 5;
        5 < 10 > 5;
        if (5 < 10) {
               return true;
           } else {
               return false;
        }

        10 == 10; 10 != 9;
        10 >= 10; 10 <= 9;

        "foobar"
        "foo bar"
        [1, 2];
        {"foo": "bar"}
        a = 42;
        var x = 10; // This is an inline comment
        // This is a comment
        /*
        multiline
        comment
        */
        3.0;
        4.555;
        """
        // swiftlint:enable indentation_width
        let tokens: [Token] = [
            Token(type: .let, literal: "let"),
            Token(type: .identifier, literal: "five"),
            Token(type: .assign, literal: "="),
            Token(type: .int, literal: "5"),
            Token(type: .semicolon, literal: ";"),
            Token(type: .let, literal: "let"),
            Token(type: .identifier, literal: "ten"),
            Token(type: .assign, literal: "="),
            Token(type: .int, literal: "10"),
            Token(type: .semicolon, literal: ";"),
            Token(type: .let, literal: "let"),
            Token(type: .identifier, literal: "add"),
            Token(type: .assign, literal: "="),
            Token(type: .function, literal: "fn"),
            Token(type: .lparen, literal: "("),
            Token(type: .identifier, literal: "x"),
            Token(type: .comma, literal: ","),
            Token(type: .identifier, literal: "y"),
            Token(type: .rparen, literal: ")"),
            Token(type: .lbrace, literal: "{"),
            Token(type: .identifier, literal: "x"),
            Token(type: .plus, literal: "+"),
            Token(type: .identifier, literal: "y"),
            Token(type: .semicolon, literal: ";"),
            Token(type: .rbrace, literal: "}"),
            Token(type: .semicolon, literal: ";"),
            Token(type: .let, literal: "let"),
            Token(type: .identifier, literal: "result"),
            Token(type: .assign, literal: "="),
            Token(type: .identifier, literal: "add"),
            Token(type: .lparen, literal: "("),
            Token(type: .identifier, literal: "five"),
            Token(type: .comma, literal: ","),
            Token(type: .identifier, literal: "ten"),
            Token(type: .rparen, literal: ")"),
            Token(type: .semicolon, literal: ";"),
            Token(type: .bang, literal: "!"),
            Token(type: .minus, literal: "-"),
            Token(type: .slash, literal: "/"),
            Token(type: .asterisk, literal: "*"),
            Token(type: .int, literal: "5"),
            Token(type: .semicolon, literal: ";"),
            Token(type: .int, literal: "5"),
            Token(type: .lt, literal: "<"),
            Token(type: .int, literal: "10"),
            Token(type: .gt, literal: ">"),
            Token(type: .int, literal: "5"),
            Token(type: .semicolon, literal: ";"),
            Token(type: .if, literal: "if"),
            Token(type: .lparen, literal: "("),
            Token(type: .int, literal: "5"),
            Token(type: .lt, literal: "<"),
            Token(type: .int, literal: "10"),
            Token(type: .rparen, literal: ")"),
            Token(type: .lbrace, literal: "{"),
            Token(type: .return, literal: "return"),
            Token(type: .true, literal: "true"),
            Token(type: .semicolon, literal: ";"),
            Token(type: .rbrace, literal: "}"),
            Token(type: .else, literal: "else"),
            Token(type: .lbrace, literal: "{"),
            Token(type: .return, literal: "return"),
            Token(type: .false, literal: "false"),
            Token(type: .semicolon, literal: ";"),
            Token(type: .rbrace, literal: "}"),
            Token(type: .int, literal: "10"),
            Token(type: .equals, literal: "=="),
            Token(type: .int, literal: "10"),
            Token(type: .semicolon, literal: ";"),
            Token(type: .int, literal: "10"),
            Token(type: .notEquals, literal: "!="),
            Token(type: .int, literal: "9"),
            Token(type: .semicolon, literal: ";"),
            Token(type: .int, literal: "10"),
            Token(type: .gte, literal: ">="),
            Token(type: .int, literal: "10"),
            Token(type: .semicolon, literal: ";"),
            Token(type: .int, literal: "10"),
            Token(type: .lte, literal: "<="),
            Token(type: .int, literal: "9"),
            Token(type: .semicolon, literal: ";"),
            Token(type: .string, literal: "foobar"),
            Token(type: .string, literal: "foo bar"),
            Token(type: .lbracket, literal: "["),
            Token(type: .int, literal: "1"),
            Token(type: .comma, literal: ","),
            Token(type: .int, literal: "2"),
            Token(type: .rbracket, literal: "]"),
            Token(type: .semicolon, literal: ";"),
            Token(type: .lbrace, literal: "{"),
            Token(type: .string, literal: "foo"),
            Token(type: .colon, literal: ":"),
            Token(type: .string, literal: "bar"),
            Token(type: .rbrace, literal: "}"),
            Token(type: .identifier, literal: "a"),
            Token(type: .assign, literal: "="),
            Token(type: .int, literal: "42"),
            Token(type: .semicolon, literal: ";"),
            Token(type: .var, literal: "var"),
            Token(type: .identifier, literal: "x"),
            Token(type: .assign, literal: "="),
            Token(type: .int, literal: "10"),
            Token(type: .semicolon, literal: ";"),
            Token(type: .comment, literal: "// This is an inline comment"),
            Token(type: .comment, literal: "// This is a comment"),
            Token(type: .comment, literal: "/*\nmultiline\ncomment\n*/"),

            Token(type: .float, literal: "3.0"),
            Token(type: .semicolon, literal: ";"),
            Token(type: .float, literal: "4.555"),
            Token(type: .semicolon, literal: ";"),
            Token(type: .eof, literal: "")
        ]

        var lexer = MonkeyLexer(withString: input)
        for token in tokens {
            let next = lexer.nextToken()
            XCTAssertEqual(next, token)
        }
    }

    func testNextTokenWithLineNumber() throws {
        // swiftlint:disable indentation_width
        let input = """
        let five = 5;
        let ten = 10;

        let add = fn(x, y) {
             x + y;
        }; // This is an inline comment
        //  This is a comment
        /*
        multiline
        comment
        */
        """
        // swiftlint:enable indentation_width
        let tokens: [Token] = [
            Token(type: .let, literal: "let", line: 1, column: 0),
            Token(type: .identifier, literal: "five", line: 1, column: 4),
            Token(type: .assign, literal: "=", line: 1, column: 9),
            Token(type: .int, literal: "5", line: 1, column: 11),
            Token(type: .semicolon, literal: ";", line: 1, column: 12),
            Token(type: .let, literal: "let", line: 2, column: 0),
            Token(type: .identifier, literal: "ten", line: 2, column: 4),
            Token(type: .assign, literal: "=", line: 2, column: 8),
            Token(type: .int, literal: "10", line: 2, column: 10),
            Token(type: .semicolon, literal: ";", line: 2, column: 12),
            Token(type: .let, literal: "let", line: 4, column: 0),
            Token(type: .identifier, literal: "add", line: 4, column: 4),
            Token(type: .assign, literal: "=", line: 4, column: 8),
            Token(type: .function, literal: "fn", line: 4, column: 10),
            Token(type: .lparen, literal: "(", line: 4, column: 12),
            Token(type: .identifier, literal: "x", line: 4, column: 13),
            Token(type: .comma, literal: ",", line: 4, column: 14),
            Token(type: .identifier, literal: "y", line: 4, column: 16),
            Token(type: .rparen, literal: ")", line: 4, column: 17),
            Token(type: .lbrace, literal: "{", line: 4, column: 19),
            Token(type: .identifier, literal: "x", line: 5, column: 5),
            Token(type: .plus, literal: "+", line: 5, column: 7),
            Token(type: .identifier, literal: "y", line: 5, column: 9),
            Token(type: .semicolon, literal: ";", line: 5, column: 10),
            Token(type: .rbrace, literal: "}", line: 6, column: 0),
            Token(type: .semicolon, literal: ";", line: 6, column: 1),
            Token(type: .comment, literal: "// This is an inline comment", line: 6, column: 3),
            Token(type: .comment, literal: "//  This is a comment", line: 7, column: 0),
            Token(type: .comment, literal: "/*\nmultiline\ncomment\n*/", line: 8, column: 0),
            Token(type: .eof, literal: "", line: 11, column: 2)
        ]

        var lexer = MonkeyLexer(withString: input)
        for token in tokens {
            let next = lexer.nextToken()
            XCTAssertEqual(next, token)
            XCTAssertEqual(next.line, token.line)
            XCTAssertEqual(next.column, token.column)
        }
    }

    func testNextTokenFromFile() throws {
        // swiftlint:disable indentation_width
        let input = """
        let five = 5;
        let ten = 10;

        let add = fn(x, y) {
             x + y;
        }; // This is an inline comment
        //  This is a comment
        /*
        multiline
        comment
        */
        """

        // swiftlint:enable indentation_width
        let tokens: [Token] = [
            Token(type: .let, literal: "let", line: 1, column: 0),
            Token(type: .identifier, literal: "five", line: 1, column: 4),
            Token(type: .assign, literal: "=", line: 1, column: 9),
            Token(type: .int, literal: "5", line: 1, column: 11),
            Token(type: .semicolon, literal: ";", line: 1, column: 12),
            Token(type: .let, literal: "let", line: 2, column: 0),
            Token(type: .identifier, literal: "ten", line: 2, column: 4),
            Token(type: .assign, literal: "=", line: 2, column: 8),
            Token(type: .int, literal: "10", line: 2, column: 10),
            Token(type: .semicolon, literal: ";", line: 2, column: 12),
            Token(type: .let, literal: "let", line: 4, column: 0),
            Token(type: .identifier, literal: "add", line: 4, column: 4),
            Token(type: .assign, literal: "=", line: 4, column: 8),
            Token(type: .function, literal: "fn", line: 4, column: 10),
            Token(type: .lparen, literal: "(", line: 4, column: 12),
            Token(type: .identifier, literal: "x", line: 4, column: 13),
            Token(type: .comma, literal: ",", line: 4, column: 14),
            Token(type: .identifier, literal: "y", line: 4, column: 16),
            Token(type: .rparen, literal: ")", line: 4, column: 17),
            Token(type: .lbrace, literal: "{", line: 4, column: 19),
            Token(type: .identifier, literal: "x", line: 5, column: 5),
            Token(type: .plus, literal: "+", line: 5, column: 7),
            Token(type: .identifier, literal: "y", line: 5, column: 9),
            Token(type: .semicolon, literal: ";", line: 5, column: 10),
            Token(type: .rbrace, literal: "}", line: 6, column: 0),
            Token(type: .semicolon, literal: ";", line: 6, column: 1),
            Token(type: .comment, literal: "// This is an inline comment", line: 6, column: 3),
            Token(type: .comment, literal: "//  This is a comment", line: 7, column: 0),
            Token(type: .comment, literal: "/*\nmultiline\ncomment\n*/", line: 8, column: 0),
            Token(type: .eof, literal: "", line: 11, column: 2)
        ]

        let file = writeToFile(input, file: "testNextTokenFromFile")
        var lexer = MonkeyLexer(withFilePath: file)
        for token in tokens {
            let next = lexer.nextToken()
            XCTAssertEqual(next, token)
            print(next.literal)
            XCTAssertEqual(next.line, token.line)
            XCTAssertEqual(next.column, token.column)
            XCTAssertEqual(next.file, file.absoluteString.replacingOccurrences(of: "file://", with: ""))
        }
    }

    func testValidIdentifiers() throws {
        let input = """
        onlyLetters;
        CAPITALS;
        _underscoreStart;
        _underscores_everywhere;
        number1;
        number200;
        number_200;
        """

        let tokens: [Token] = [
            Token(type: .identifier, literal: "onlyLetters", line: 1, column: 0),
            Token(type: .semicolon, literal: ";", line: 1, column: 11),
            Token(type: .identifier, literal: "CAPITALS", line: 2, column: 0),
            Token(type: .semicolon, literal: ";", line: 2, column: 8),
            Token(type: .identifier, literal: "_underscoreStart", line: 3, column: 0),
            Token(type: .semicolon, literal: ";", line: 3, column: 16),
            Token(type: .identifier, literal: "_underscores_everywhere", line: 4, column: 0),
            Token(type: .semicolon, literal: ";", line: 4, column: 23),
            Token(type: .identifier, literal: "number1", line: 5, column: 0),
            Token(type: .semicolon, literal: ";", line: 5, column: 7),
            Token(type: .identifier, literal: "number200", line: 6, column: 0),
            Token(type: .semicolon, literal: ";", line: 6, column: 9),
            Token(type: .identifier, literal: "number_200", line: 7, column: 0),
            Token(type: .semicolon, literal: ";", line: 7, column: 10)
        ]

        var lexer = MonkeyLexer(withString: input)
        for token in tokens {
            let next = lexer.nextToken()
            XCTAssertEqual(next, token)
            XCTAssertEqual(next.line, token.line)
            XCTAssertEqual(next.column, token.column)
        }
    }

    func writeToFile(_ string: String, file: String) -> URL {
        let path = FileManager.default.temporaryDirectory
        let filePath = path.appendingPathComponent(file)
        print()
        do {
            try string.write(to: filePath, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }

        return filePath
    }
}
