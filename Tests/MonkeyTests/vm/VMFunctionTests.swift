//
//  VMFunctionTests.swift
//  MonkeyTests
//
//  Created by Franklin Cruz on 11-03-21.
//

import XCTest
@testable import Rosetta
@testable import MonkeyLang

// swiftlint:disable type_body_length function_body_length
class VMFunctionTests: XCTestCase, VMTestsHelpers {
    func testCallingFunctionsWithoutArguments() throws {
        let tests: [VMTestCase] = [
            VMTestCase(
                "let fivePlusTen = fn() { 5 + 10; }; \n fivePlusTen();",
                Integer(15)
            ),
            VMTestCase(
                """
                let one = fn() { 1; };
                let two = fn() { 2; };
                one() + two()
                """,
                Integer(3)
            ),
            VMTestCase(
                """
                let a = fn() { 1 };
                let b = fn() { a() + 1 };
                let c = fn() { b() + 1 };
                c();
                """,
                Integer(3)
            )
        ]

        try self.runVMTests(tests)
    }

    func testCallingFunctionsWithReturnStatement() throws {
        let tests: [VMTestCase] = [
            VMTestCase(
                """
                let earlyExit  = fn() { return 99; 100; };
                earlyExit();
                """,
                Integer(99)
            ),
            VMTestCase(
                """
                let earlyExit  = fn() { return 99; return 100; };
                earlyExit();
                """,
                Integer(99)
            )
        ]

        try self.runVMTests(tests)
    }

    func testCallingFunctionsWithoutReturnValue() throws {
        let tests: [VMTestCase] = [
            VMTestCase(
                """
                let noReturn = fn() { };
                noReturn();
                """,
                Null.null
            ),
            VMTestCase(
                """
                let noReturn = fn() { };
                let noReturnTwo = fn() { noReturn(); };
                noReturn();
                noReturnTwo();
                """,
                Null.null
            )
        ]

        try self.runVMTests(tests)
    }

    func testFirstClassFunctions() throws {
        let tests: [VMTestCase] = [
            VMTestCase(
                """
                let returnsOne = fn() { 1; };
                let returnsOneReturner = fn() { returnsOne; };
                returnsOneReturner()();
                """,
                Integer(1)
            )
        ]

        try self.runVMTests(tests)
    }

    func testCallFunctionsWithBindings() throws {
        let tests: [VMTestCase] = [
            VMTestCase(
                """
                let one = fn() { let one = 1; one };
                one();
                """,
                Integer(1)
            ),
            VMTestCase(
                """
                let oneAndTwo = fn() { let one = 1; let two = 2; one + two; };
                oneAndTwo();
                """,
                Integer(3)
            ),
            VMTestCase(
                """
                let firstFoobar = fn() { let foobar = 50; foobar; };
                let secondFoobar = fn() { let foobar = 100; foobar; };
                firstFoobar() + secondFoobar();
                """,
                Integer(150)
            ),
            VMTestCase(
                """
                let globalSeed = 50;
                let minusOne = fn() {
                    let num = 1;
                    globalSeed - num;
                };
                let minusTwo = fn() {
                    let num = 2;
                    globalSeed - num;
                };
                minusOne() + minusTwo();
                """,
                Integer(97)
            )
        ]

        try self.runVMTests(tests)
    }

    func testCallFunctionsWithArgumentsBindings() throws {
        let tests: [VMTestCase] = [
            VMTestCase(
                """
                let identity = fn(a) { a; };
                identity(4);
                """,
                Integer(4)
            ),
            VMTestCase(
                """
                let sum = fn(a, b) { a + b; };
                sum(1, 2);
                """,
                Integer(3)
            ),
            VMTestCase(
                """
                let sum = fn(a, b) {
                    let c = a + b;
                    c;
                };
                sum(1, 2);
                """,
                Integer(3)
            ),
            VMTestCase(
                """
                let sum = fn(a, b) {
                    let c = a + b;
                    c;
                };
                sum(1, 2) + sum(3, 4);
                """,
                Integer(10)
            ),
            VMTestCase(
                """
                let sum = fn(a, b) {
                    let c = a + b;
                    c;
                };
                let outer = fn() {
                    sum(1, 2) + sum(3, 4);
                };
                outer();
                """,
                Integer(10)
            ),
            VMTestCase(
                """
                let globalNum = 10;
                    let sum = fn(a, b) {
                    let c = a + b;
                    c + globalNum;
                };
                let outer = fn() {
                    sum(1, 2) + sum(3, 4) + globalNum;
                };
                outer() + globalNum;
                """,
                Integer(50)
            )
        ]

        try self.runVMTests(tests)
    }

    func testCallFunctionsWithoutArgumentsBindings() throws {
        let tests: [VMTestCase] = [
            VMTestCase(
                "fn() { 1; }(1);",
                Null.null
            ),
            VMTestCase(
                "fn(a) { a; }();",
                Null.null
            ),
            VMTestCase(
                "fn(a, b) { a + b; }(1);",
                Null.null
            )
        ]

        let errors = [
            "Incorrect number of arguments in function call expected: 0 but got: 1",
            "Incorrect number of arguments in function call expected: 1 but got: 0",
            "Incorrect number of arguments in function call expected: 2 but got: 1"
        ]

        for testIndex in 0..<tests.count {
            do {
                try self.runVMTest(tests[testIndex])
            } catch let error as WrongArgumentCount {
                XCTAssertEqual(errors[testIndex], error.description)
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }

    func testBuiltinFunctions() throws {
        let tests = [
            VMTestCase("len(\"\")", Integer(0)),
            VMTestCase("len(\"four\")", Integer(4)),
            VMTestCase("len(\"hello world\")", Integer(11)),
            VMTestCase("len(1)", Null.null, "Incorrect argment type expected: String or Array got: Integer"), // Error
            VMTestCase(
                "len(\"one\", \"two\")",
                Null.null,
                "Incorrect number of arguments in function call expected: 1 but got: 2"
            ), // Error
            VMTestCase("len([1, 2, 3])", Integer(3)),
            VMTestCase("len([])", Integer(0)),
            VMTestCase("puts(\"hello world\")", Null.null),
            VMTestCase("first([1, 2, 3])", Integer(1)),
            VMTestCase("first([])", Null.null),
            VMTestCase("first(1)", Null.null, "Incorrect argment type expected: Array got: Integer"),
            VMTestCase("last([1, 2, 3])", Integer(3)),
            VMTestCase("last([])", Null.null),
            VMTestCase("last(1)", Null.null, "Incorrect argment type expected: Array got: Integer"),
            VMTestCase("rest([1, 2, 3])", MArray(elements: [Integer(2), Integer(3)])),
            VMTestCase("rest([])", Null.null),
            VMTestCase("push([], 1)", MArray(elements: [Integer(1)])),
            VMTestCase("push(1, 1)", Null.null, "Incorrect argment type expected: Array got: Integer")
        ]

        for test in tests {
            do {
                try self.runVMTest(test)
            } catch let error as InvalidArgumentType {
                XCTAssertEqual(test.error, error.description)
            } catch let error as WrongArgumentCount {
                XCTAssertEqual(test.error, error.description)
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }

    func testClosures() throws {
        let tests: [VMTestCase] = [
            VMTestCase(
                """
                let newClosure = fn(a) {
                    fn() { a; }
                };
                let closure = newClosure(99);
                closure();
                """,
                Integer(99)
            ),
            VMTestCase(
                """
                let newAdder = fn(a, b) {
                    fn(c) { a + b + c };
                };
                let adder = newAdder(1, 2);
                adder(8);
                """,
                Integer(11)
            ),
            VMTestCase(
                """
                let newAdder = fn(a, b) {
                    let c = a + b;
                    fn(d) { c + d };
                };
                let adder = newAdder(1, 2);
                adder(8);
                """,
                Integer(11)
            ),
            VMTestCase(
                """
                let newAdderOuter = fn(a, b) {
                    let c = a + b;
                    fn(d) {
                        let e = d + c;
                        fn(f) { e + f; };
                    };
                };
                let newAdderInner = newAdderOuter(1, 2);
                let adder = newAdderInner(3);
                adder(8);
                """,
                Integer(14)
            ),
            VMTestCase(
                """
                let a = 1;
                let newAdderOuter = fn(b) {
                    fn(c) {
                        fn(d) { a + b + c + d };
                    };
                };
                let newAdderInner = newAdderOuter(2);
                let adder = newAdderInner(3);
                adder(8);
                """,
                Integer(14)
            ),
            VMTestCase(
                """
                let newClosure = fn(a, b) {
                    let one = fn() { a; };
                    let two = fn() { b; };
                    fn() { one() + two(); };
                };
                let closure = newClosure(9, 90);
                closure();
                """,
                Integer(99)
            )
        ]

        try self.runVMTests(tests)
    }

    func testRecursiveFunctions() throws {
        let tests = [
            VMTestCase(
                """
                let countDown = fn(x) {
                    if (x == 0) {
                        return 0;
                    } else {
                        countDown(x - 1);
                    }
                };
                countDown(1);
                """,
                Integer(0)
            ),
            VMTestCase(
                """
                let wrapper = fn() {
                    let countDown = fn(x) {
                        if (x == 0) {
                            return 0;
                        } else {
                            countDown(x - 1);
                        }
                    };
                    countDown(1);
                };
                wrapper();
                """,
                Integer(0)
            )
        ]

        try self.runVMTests(tests)
    }
}
