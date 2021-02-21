//
//  VMTests.swift
//  MonkeyTests
//
//  Created by Franklin Cruz on 03-02-21.
//

import XCTest
@testable import Rosetta
@testable import MonkeyLang

class VMTests: XCTestCase {
    typealias TestCase = (input: String, expected: Object)

    func testIntegerArithmetic() throws {
        let tests: [TestCase] = [
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
        let tests: [TestCase] = [
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

    func testConditionals() throws {
        let tests: [TestCase] = [
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
        let tests: [TestCase] = [
            ("let one = 1; one;", Integer(1)),
            ("let one = 1; let two = 2; one + two", Integer(3)),
            ("let one = 1; let two = one + one; one + two", Integer(3)),
            // This should fail because we are trying to assing a let value
            ("let fail = 1; fail = 10;", Null.null),
            // This should fail because we are trying to create a new global with the same name
            ("let fail = 1; let fail = 10;", Null.null)
        ]

        do {
            try self.runVMTests(tests)
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

    func testGlobalVarStatements() throws {
        let tests: [TestCase] = [
            ("var one = 1; one;", Integer(1)),
            ("var one = 1; var two = 2; one + two", Integer(3)),
            ("var one = 1; var two = one + one; one + two", Integer(3)),
            ("var one = 1; one = 3; one", Integer(3))
        ]

        try self.runVMTests(tests)
    }

    // MARK: Utils

    func runVMTests(_ tests: [TestCase], file: StaticString = #file, line: UInt = #line) throws {
        for test in tests {
            let program = try parse(test.input)
            var compiler = MonkeyC()
            try compiler.compile(program)
            let bytecode = compiler.bytecode
            var vm = VM(bytecode, operations: MonkeyVMOperations())
            try vm.run()

            let element = vm.lastPoped
            XCTAssert(
                element?.isEquals(other: test.expected) ?? false,
                "\(element?.description ?? "nil") is not equal to \(test.expected)"
            )
        }
    }

    func parse(_ input: String, file: StaticString = #file, line: UInt = #line) throws -> Program {
        let lexer = MonkeyLexer(withString: input)
        var parser = MonkeyParser(lexer: lexer)
        guard let program = try parser.parseProgram() else {
            XCTFail("Resulting program is nil")
            return Program(statements: [])
        }

        return program
    }
}
