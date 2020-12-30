//
//  LexerTest.swift
//  rosettaTest
//
//  Created by Franklin Cruz on 28-12-20.
//

import XCTest

class LexerTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testReadIdentifier() throws {
        var input = "myIdentifer"
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

    func testNextToken() throws {
        let input = """
        let five = 5;
        let ten = 10;
        
        let add = fn(x, y) {
             x + y;
        };

        let result = add(five, ten);
        !-/*5;
        5 < 10 > 5;
        if (5 < 10) {
               return true;
           } else {
               return false;
        }

        10 == 10; 10 != 9;
        10 >= 10; 10 <= 9;
        """
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
            Token(type: .eof, literal: "")
        ]
        
        var lexer = MonkeyLexer(withString: input)
        for t in tokens {
            let next = lexer.nextToken()
            XCTAssertEqual(next, t)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
