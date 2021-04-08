//
//  MonkeyCErrorTests.swift
//  MonkeyTests
//
//  Created by Franklin Cruz on 07-04-21.
//

import XCTest
@testable import Hermes
@testable import MonkeyLang

class MonkeyCErrorTests: XCTestCase, CompilerTestsHelpers {
    func testErrors() throws {
        let tests = [
            (
                "let a = 10;\n notResolved",
                "Name \"notResolved\" not resolvable at Line: 2, Column: 1"
            ),
            (
                "let a = 10;\n\n a = 100;",
                "Cannot assign to value: \"a\" is a constant at Line: 3, Column: 1"
            ),
            (
                "let a = 10;\n\nvar a = 100;",
                "Cannot redeclare: \"a\" it already exists at Line: 3, Column: 0"
            )
        ]

        for test in tests {
            do {
                _ = try self.compile(test.0)
                XCTFail("Compiler must throw an error")
            } catch let error as CompilerError {
                XCTAssertEqual(test.1, error.description)
            } catch {
                XCTFail("Unexpected Error \(error)")
            }
        }
    }
}
