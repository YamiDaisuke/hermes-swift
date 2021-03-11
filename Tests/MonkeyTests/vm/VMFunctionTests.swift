//
//  VMFunctionTests.swift
//  MonkeyTests
//
//  Created by Franklin Cruz on 11-03-21.
//

import XCTest
@testable import Rosetta
@testable import MonkeyLang


class VMFunctionTests: XCTestCase, VMTestsHelpers {
    func testCallingFunctionsWithoutArguments() throws {
        let tests: [VMTestCase] = [
            (
                "let fivePlusTen = fn() { 5 + 10; }; \n fivePlusTen();",
                Integer(15)
            ),
            (
                """
                let one = fn() { 1; };
                let two = fn() { 2; };
                one() + two()
                """,
                Integer(3)
            ),
            (
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
            (
                """
                let earlyExit  = fn() { return 99; 100; };
                earlyExit();
                """,
                Integer(99)
            ),
            (
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
            (
                """
                let noReturn = fn() { };
                noReturn();
                """,
                Null.null
            ),
            (
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
            (
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
            (
                """
                let one = fn() { let one = 1; one };
                one();
                """,
                Integer(1)
            ),
            (
                """
                let oneAndTwo = fn() { let one = 1; let two = 2; one + two; };
                oneAndTwo();
                """,
                Integer(3)
            ),
            (
                """
                let firstFoobar = fn() { let foobar = 50; foobar; };
                let secondFoobar = fn() { let foobar = 100; foobar; };
                firstFoobar() + secondFoobar();
                """,
                Integer(150)
            ),
            (
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
}
