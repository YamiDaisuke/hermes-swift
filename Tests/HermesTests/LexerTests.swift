//
//  LexerTest.swift
//  rosettaTest
//
//  Created by Franklin Cruz on 28-12-20.
//

import XCTest
@testable import Hermes

class LexerTest: XCTestCase {
    struct AStringLexer: Lexer, StringLexer {
        var readingChars: (current: Character?, next: Character?)?

        var currentLineNumber = 0
        var currentColumn = 0
        var currentLine = ""
        var readCharacterCount = 0

        mutating func nextToken() -> Token {
            return Token.init(type: .eof, literal: "")
        }

        var input: String

        mutating func readLine() {
            readStringLine()
        }
    }

    struct AFileLexer: Lexer, FileLexer {
        var readingChars: (current: Character?, next: Character?)?

        var currentLineNumber = 0
        var currentColumn = 0
        var currentLine = ""
        var readCharacterCount = 0

        var filePath: URL?
        var streamReader: StreamReader?

        init(filePath: URL) {
            self.filePath = filePath
            self.streamReader = StreamReader(url: filePath)
        }

        mutating func nextToken() -> Token {
            return Token.init(type: .eof, literal: "")
        }

        mutating func readLine() {
            readFileLine()
        }
    }

    func testReadChar() throws {
        let input = "My\nline\n"

        var lexer = AStringLexer(input: input)
        lexer.readLine()
        lexer.readChar()
        var output = lexer.readingChars
        XCTAssertEqual(lexer.currentColumn, 0)
        XCTAssertEqual(lexer.currentLineNumber, 1)
        XCTAssertEqual(output?.current, "M")
        XCTAssertEqual(output?.next, "y")
        lexer.readChar()
        output = lexer.readingChars
        XCTAssertEqual(lexer.currentColumn, 1)
        XCTAssertEqual(lexer.currentLineNumber, 1)
        XCTAssertEqual(output?.current, "y")
        XCTAssertEqual(output?.next, "\n")
        lexer.readChar()
        output = lexer.readingChars
        XCTAssertEqual(lexer.currentColumn, 0)
        XCTAssertEqual(lexer.currentLineNumber, 2)
        XCTAssertEqual(output?.current, "l")
        XCTAssertEqual(output?.next, "i")
        lexer.readChar()
        output = lexer.readChar()
        XCTAssertEqual(lexer.currentColumn, 2)
        XCTAssertEqual(lexer.currentLineNumber, 2)
        XCTAssertEqual(output?.current, "n")
        XCTAssertEqual(output?.next, "e")
        output = lexer.readChar()
        XCTAssertEqual(lexer.currentColumn, 3)
        XCTAssertEqual(lexer.currentLineNumber, 2)
        XCTAssertEqual(output?.current, "e")
        XCTAssertEqual(output?.next, "\n")
        output = lexer.readChar()
        XCTAssertEqual(lexer.currentColumn, 0)
        XCTAssertEqual(lexer.currentLineNumber, 3)
        XCTAssertEqual(output?.current, nil)
        XCTAssertEqual(output?.next, nil)

        lexer = AStringLexer(input: "li")
        lexer.readLine()
        lexer.readChar()
        output = lexer.readChar()
        XCTAssertEqual(lexer.currentColumn, 1)
        XCTAssertEqual(lexer.currentLineNumber, 1)
        XCTAssertEqual(output?.current, "i")
        XCTAssertEqual(output?.next, nil)
        output = lexer.readChar()
        XCTAssertEqual(output?.current, nil)
        XCTAssertEqual(output?.next, nil)
    }

    func testReadStringline() throws {
        // Ideal case
        let input = "My Text with\nline breaks\n"

        var lexer = AStringLexer(input: input)
        lexer.readLine()
        XCTAssertEqual(lexer.currentLine, "My Text with\n")
        XCTAssertEqual(lexer.currentColumn, -1)
        XCTAssertEqual(lexer.currentLineNumber, 1)
        XCTAssertEqual(lexer.readCharacterCount, "My Text with\n".count)
        lexer.readLine()
        XCTAssertEqual(lexer.currentLine, "line breaks\n")
        XCTAssertEqual(lexer.currentColumn, -1)
        XCTAssertEqual(lexer.currentLineNumber, 2)
        XCTAssertEqual(lexer.readCharacterCount, input.count)

        // Empty String

        lexer = AStringLexer(input: "")
        lexer.readLine()
        XCTAssertEqual(lexer.currentLine, "")
        XCTAssertEqual(lexer.currentColumn, -1)
        XCTAssertEqual(lexer.currentLineNumber, 1)
        XCTAssertEqual(lexer.readCharacterCount, 0)

        // Initial empty line

        lexer = AStringLexer(input: "\nHello there")
        lexer.readLine()
        XCTAssertEqual(lexer.currentLine, "\n")
        XCTAssertEqual(lexer.currentColumn, -1)
        XCTAssertEqual(lexer.currentLineNumber, 1)
        XCTAssertEqual(lexer.readCharacterCount, 1)
        lexer.readLine()
        XCTAssertEqual(lexer.currentLine, "Hello there")
        XCTAssertEqual(lexer.currentColumn, -1)
        XCTAssertEqual(lexer.currentLineNumber, 2)
        XCTAssertEqual(lexer.readCharacterCount, lexer.input.count)
    }

    func testReadFileString() throws {
        // Ideal case
        let input = "My Text with\nline breaks\n"

        var lexer = AFileLexer(filePath: writeToFile(input, file: "idealcase.mky"))
        lexer.readLine()
        XCTAssertEqual(lexer.currentLine, "My Text with\n")
        XCTAssertEqual(lexer.currentColumn, -1)
        XCTAssertEqual(lexer.currentLineNumber, 1)
        XCTAssertEqual(lexer.readCharacterCount, "My Text with\n".count)
        lexer.readLine()
        XCTAssertEqual(lexer.currentLine, "line breaks\n")
        XCTAssertEqual(lexer.currentColumn, -1)
        XCTAssertEqual(lexer.currentLineNumber, 2)
        XCTAssertEqual(lexer.readCharacterCount, input.count)

        // Empty String

        lexer = AFileLexer(filePath: writeToFile("", file: "empty.mky"))
        lexer.readLine()
        XCTAssertEqual(lexer.currentLine, "")
        XCTAssertEqual(lexer.currentColumn, -1)
        XCTAssertEqual(lexer.currentLineNumber, 1)
        XCTAssertEqual(lexer.readCharacterCount, 0)

        // Initial empty line

        lexer = AFileLexer(filePath: writeToFile("\nHello there", file: "firstlineempty.mky"))
        lexer.readLine()
        XCTAssertEqual(lexer.currentLine, "\n")
        XCTAssertEqual(lexer.currentColumn, -1)
        XCTAssertEqual(lexer.currentLineNumber, 1)
        XCTAssertEqual(lexer.readCharacterCount, 1)
        lexer.readLine()
        XCTAssertEqual(lexer.currentLine, "Hello there")
        XCTAssertEqual(lexer.currentColumn, -1)
        XCTAssertEqual(lexer.currentLineNumber, 2)
        XCTAssertEqual(lexer.readCharacterCount, 12)
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
