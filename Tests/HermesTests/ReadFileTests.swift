//
//  ReadFileTests.swift
//  MonkeyTests
//
//  Created by Franklin Cruz on 25-01-21.
//

import XCTest
@testable import Hermes

class ReadFileTests: XCTestCase {
    // swiftlint:disable:next implicitly_unwrapped_optional
    var filePath: URL!

    override func setUp() {
        super.setUp()
        let str = """

        puts("Hello World!")
        puts("Bye World!")

        let a = 10;
        """
        let path = FileManager.default.temporaryDirectory
        self.filePath = path.appendingPathComponent("test.mky")
        do {
            try str.write(to: self.filePath, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
    }

    func testStreamReader() throws {
        let reader = StreamReader(url: filePath)
        XCTAssertNotNil(reader)

        let expected = [
            "\n",
            "puts(\"Hello World!\")\n",
            "puts(\"Bye World!\")\n",
            "\n",
            "let a = 10;"
        ]
        var current = 0

        var line = reader?.nextLine()
        XCTAssertNotNil(line)
        while line != nil {
            XCTAssertEqual(line, expected[current])
            current += 1
            line = reader?.nextLine()
        }
    }
}
