//
//  File.swift
//  MonkeyTests
//
//  Created by Franklin Cruz on 11-03-21.
//

import XCTest
@testable import Rosetta
@testable import MonkeyLang

protocol VMTestsHelpers {
}

struct VMTestCase {
    var input: String
    var expected: Object
    var error: String?

    init(_ input: String, _ expected: Object, _ error: String? = nil) {
        self.input = input
        self.expected = expected
        self.error = error
    }
}

extension VMTestsHelpers {
    func runVMTests(_ tests: [VMTestCase], file: StaticString = #file, line: UInt = #line) throws {
        for test in tests {
            try runVMTest(test)
        }
    }

    func runVMTest(_ test: VMTestCase, file: StaticString = #file, line: UInt = #line) throws {
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
