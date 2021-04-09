//
//  BuiltinFunctionsTests.swift
//  MonkeyTests
//
//  Created by Franklin Cruz on 19-01-21.
//

import XCTest
@testable import Hermes
@testable import MonkeyLang

class BuiltinFunctionsTests: XCTestCase {
    func testLenFunction() throws {
        let tests: [(String, Any)] = [
            ("len(\"\")", Int32(0)),
            ("len(\"four\")", Int32(4)),
            ("len(\"Hello World\")", Int32(11)),
            ("len([1, 2])", Int32(2)),
            ("len([])", Int32(0)),
            ("len(1)", "Incorrect argment type expected: String or Array got: Integer at Line: 1, Column: 3"),
            (
                "len(\"one\", \"two\")",
                "Incorrect number of arguments in function call expected: 1 but got: 2 at Line: 1, Column: 3"
            )
        ]

        for test in tests {
            do {
                let evaluated = try Utils.testEval(input: test.0, environment: Environment())
                MKAssertInteger(object: evaluated, expected: test.1 as? Int32 ?? -1)
            } catch let error as WrongArgumentCount {
                XCTAssertEqual(error.description, test.1 as? String ?? "")
            } catch let error as InvalidArgumentType {
                XCTAssertEqual(error.description, test.1 as? String ?? "")
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }

    func testFirstFunction() throws {
        let tests: [(String, Any?)] = [
            ("first([1, 2])", Int32(1)),
            ("first([])", nil),
            ("first(1)", "Incorrect argment type expected: Array got: Integer at Line: 1, Column: 5"),
            (
                "first(\"one\", \"two\")",
                "Incorrect number of arguments in function call expected: 1 but got: 2 at Line: 1, Column: 5"
            )
        ]

        for test in tests {
            do {
                let evaluated = try Utils.testEval(input: test.0, environment: Environment())
                if let expected = test.1 as? Int32 {
                    MKAssertInteger(object: evaluated, expected: expected)
                } else {
                    XCTAssert((evaluated == Null.null).value)
                }
            } catch let error as WrongArgumentCount {
                XCTAssertEqual(error.description, test.1 as? String ?? "")
            } catch let error as InvalidArgumentType {
                XCTAssertEqual(error.description, test.1 as? String ?? "")
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }

    func testLastFunction() throws {
        let tests: [(String, Any?)] = [
            ("last([1, 2])", Int32(2)),
            ("last([])", nil),
            ("last(1)", "Incorrect argment type expected: Array got: Integer at Line: 1, Column: 4"),
            (
                "last(\"one\", \"two\")",
                "Incorrect number of arguments in function call expected: 1 but got: 2 at Line: 1, Column: 4"
            )
        ]

        for test in tests {
            do {
                let evaluated = try Utils.testEval(input: test.0, environment: Environment())
                if let expected = test.1 as? Int32 {
                    MKAssertInteger(object: evaluated, expected: expected)
                } else {
                    XCTAssert((evaluated == Null.null).value)
                }
            } catch let error as WrongArgumentCount {
                XCTAssertEqual(error.description, test.1 as? String ?? "")
            } catch let error as InvalidArgumentType {
                XCTAssertEqual(error.description, test.1 as? String ?? "")
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }

    func testPushFunction() throws {
        let tests: [(String, Any?)] = [
            ("push([1, 2], 3)", 3),
            ("push([], 1)", 1),
            ("push(1, 1)", "Incorrect argment type expected: Array got: Integer at Line: 1, Column: 4"),
            (
                "push([])",
                "Incorrect number of arguments in function call expected: 2 but got: 1 at Line: 1, Column: 4"
            )
        ]

        for test in tests {
            do {
                let evaluated = try Utils.testEval(input: test.0, environment: Environment()) as? MArray
                if let expected = test.1 as? Int {
                    XCTAssertEqual(evaluated?.elements.count, expected)
                } else {
                    XCTAssert((evaluated == Null.null).value)
                }
            } catch let error as WrongArgumentCount {
                XCTAssertEqual(error.description, test.1 as? String ?? "")
            } catch let error as InvalidArgumentType {
                XCTAssertEqual(error.description, test.1 as? String ?? "")
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }

    func testRestFunction() throws {
        let tests: [(String, Any?)] = [
            ("rest([1, 2])", 1),
            ("rest([1])", 0),
            ("rest([])", nil),
            ("rest(1)", "Incorrect argment type expected: Array got: Integer at Line: 1, Column: 4"),
            (
                "rest(1, 2)",
                "Incorrect number of arguments in function call expected: 1 but got: 2 at Line: 1, Column: 4"
            )
        ]

        for test in tests {
            do {
                let evaluated = try Utils.testEval(input: test.0, environment: Environment())
                if let expected = test.1 as? Int {
                    let array = evaluated as? MArray
                    XCTAssertEqual(array?.elements.count, expected)
                } else {
                    XCTAssert((evaluated == Null.null).value)
                }
            } catch let error as WrongArgumentCount {
                XCTAssertEqual(error.description, test.1 as? String ?? "")
            } catch let error as InvalidArgumentType {
                XCTAssertEqual(error.description, test.1 as? String ?? "")
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }
}
