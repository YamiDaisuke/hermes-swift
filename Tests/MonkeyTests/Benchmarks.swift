//
//  Benchmarks.swift
//  MonkeyTests
//
//  Created by Franklin Cruz on 30-03-21.
//

import XCTest
@testable import Rosetta
@testable import MonkeyLang

class Benchmarks: XCTestCase {
    func testInterpreterPerformance() throws {
        self.measure {
            let input = """
            let fibonacci = fn(x) {
                if (x == 0) {
                    0
                } else {
                    if (x == 1) {
                        return 1;
                    } else {
                        fibonacci(x - 1) + fibonacci(x - 2);
                    }
                }
            };
            fibonacci(35);
            """
            let env = Environment<Object>()
            XCTAssertNoThrow {
                _ = try Utils.testEval(input: input, environment: env)
            }
        }
    }

    func testCompilerPerformance() throws {
        self.measure {
            let input = """
            let fibonacci = fn(x) {
                if (x == 0) {
                    0
                } else {
                    if (x == 1) {
                        return 1;
                    } else {
                        fibonacci(x - 1) + fibonacci(x - 2);
                    }
                }
            };
            fibonacci(35);
            """
            XCTAssertNoThrow {
                let lexer = MonkeyLexer(withString: input)
                var parser = MonkeyParser(lexer: lexer)
                let program = try parser.parseProgram() ?? Program(statements: [])
                var compiler = MonkeyC()
                try compiler.compile(program)
                let bytecode = compiler.bytecode
                var vm = VM(bytecode, operations: MonkeyVMOperations())
                try vm.run()
            }
        }
    }
}
