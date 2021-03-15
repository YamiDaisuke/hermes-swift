//
//  VMTests.swift
//  MonkeyTests
//
//  Created by Franklin Cruz on 03-02-21.
//

import XCTest
@testable import Rosetta
@testable import MonkeyLang

class VMTests: XCTestCase, VMTestsHelpers {
    func testIntegerArithmetic() throws {
        let tests: [VMTestCase] = [
            ("1", Integer(1)),
            ("2", Integer(2)),
            ("1 + 2", Integer(3)),
            ("1 - 2", Integer(-1)),
            ("1 * 2", Integer(2)),
            ("4 / 2", Integer(2)),
            ("50 / 2 * 2 + 10 - 5", Integer(55)),
            ("5 + 5 + 5 + 5 - 10", Integer(10)),
            ("2 * 2 * 2 * 2 * 2", Integer(32)),
            ("5 * 2 + 10", Integer(20)),
            ("5 + 2 * 10", Integer(25)),
            ("5 * (2 + 10)", Integer(60)),
            ("-5", Integer(-5)),
            ("-10", Integer(-10)),
            ("-50 + 100 + -50", Integer(0)),
            ("(5 + 10 * 2 + 15 / 3) * 2 + -10", Integer(50))
        ]

        try self.runVMTests(tests)
    }

    func testBooleanExpressions() throws {
        let tests: [VMTestCase] = [
            ("true", Boolean.true),
            ("false", Boolean.false),
            ("1 < 2", Boolean.true),
            ("1 > 2", Boolean.false),
            ("1 >= 2", Boolean.false),
            ("1 <= 2", Boolean.true),
            ("1 < 1", Boolean.false),
            ("1 <= 1", Boolean.true),
            ("1 > 1", Boolean.false),
            ("1 >= 1", Boolean.true),
            ("1 == 1", Boolean.true),
            ("1 != 1", Boolean.false),
            ("1 == 2", Boolean.false),
            ("1 != 2", Boolean.true),
            ("true == true", Boolean.true),
            ("false == false", Boolean.true),
            ("true == false", Boolean.false),
            ("true != false", Boolean.true),
            ("false != true", Boolean.true),
            ("(1 < 2) == true", Boolean.true),
            ("(1 < 2) == false", Boolean.false),
            ("(1 > 2) == true", Boolean.false),
            ("(1 > 2) == false", Boolean.true),
            ("(1 <= 2) == true", Boolean.true),
            ("(1 <= 2) == false", Boolean.false),
            ("(1 >= 2) == true", Boolean.false),
            ("(1 >= 2) == false", Boolean.true),
            ("!true", Boolean.false),
            ("!false", Boolean.true),
            ("!5", Boolean.false),
            ("!!true", Boolean.true),
            ("!!false", Boolean.false),
            ("!!5", Boolean.true),
            ("!(if (false) { 5; })", Boolean.true)
        ]

        try self.runVMTests(tests)
    }

    func testStringExpressions() throws {
        let tests: [VMTestCase] = [
            ("\"monkey\"", MString("monkey")),
            ("\"mon\" + \"key\"", MString("monkey")),
            ("\"mon\" + \"key\" + \"banana\"", MString("monkeybanana")),
            ("\"mon\" + \"key\" + 2", MString("monkey2"))
        ]

        try self.runVMTests(tests)
    }

    func testConditionals() throws {
        let tests: [VMTestCase] = [
            ("if (true) { 10 }", Integer(10)),
            ("if (true) { 10 } else { 20 }", Integer(10)),
            ("if (false) { 10 } else { 20 }", Integer(20)),
            ("if (1) { 10 }", Integer(10)),
            ("if (1 < 2) { 10 }", Integer(10)),
            ("if (1 < 2) { 10 } else { 20 }", Integer(10)),
            ("if (1 > 2) { 10 } else { 20 }", Integer(20)),
            ("if (1 > 2) { 10 }", Null.null),
            ("if (false) { 10 }", Null.null),
            ("if ((if (false) { 10 })) { 10 } else { 20 }", Integer(20))
        ]

        try self.runVMTests(tests)
    }

    func testGlobalLetStatements() throws {
        let tests: [VMTestCase] = [
            ("let one = 1; one;", Integer(1)),
            ("let one = 1; let two = 2; one + two", Integer(3)),
            ("let one = 1; let two = one + one; one + two", Integer(3)),
            // This should fail because we are trying to assing a let value
            ("let fail = 1; fail = 10;", Null.null),
            // This should fail because we are trying to create a new global with the same name
            ("let fail = 1; let fail = 10;", Null.null)
        ]

        for test in tests {
            do {
                try self.runVMTest(test)
            } catch let error as AssignConstantError {
                // How awesome it is that we catch the error at compile time!!
                XCTAssertEqual(error.message, "Cannot assign to value: \"fail\" is a constant")
            } catch let error as RedeclarationError {
                // How awesome it is that we catch the error at compile time!!
                XCTAssertEqual(error.message, "Cannot redeclare: \"fail\" it already exists")
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }

    func testGlobalVarStatements() throws {
        let tests: [VMTestCase] = [
            ("var one = 1; one;", Integer(1)),
            ("var one = 1; var two = 2; one + two", Integer(3)),
            ("var one = 1; var two = one + one; one + two", Integer(3)),
            ("var one = 1; one = 3; one", Integer(3))
        ]

        try self.runVMTests(tests)
    }
}
