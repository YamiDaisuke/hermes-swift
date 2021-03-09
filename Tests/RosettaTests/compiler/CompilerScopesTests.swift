//
//  CompilerScopesTests.swift
//  RosettaTests
//
//  Created by Franklin Cruz on 26-02-21.
//

import XCTest
@testable import Rosetta

private struct DummyType {  }
private struct DummyCompiler: Compiler {
    typealias BaseType = DummyType

    var instructions: Instructions = []

    var scopes: [CompilationScope] = [CompilationScope()]
    var scopeIndex = 0
    var constants: [DummyType] = []
    var symbolTable = SymbolTable()

    init() {
    }

    mutating func compile(_ program: Program) throws {
    }

    mutating func compile(_ node: Node) throws {
    }
}

class CompilerScopesTests: XCTestCase {
    func testCompilerScopes() throws {
        var compiler = DummyCompiler()
        let globalSymbolTable = compiler.symbolTable
        XCTAssertEqual(compiler.scopeIndex, 0)
        compiler.emit(.mul)

        compiler.enterScope()
        XCTAssertEqual(compiler.scopeIndex, 1)
        compiler.emit(.sub)
        XCTAssertEqual(compiler.currentScope.instructions.count, 1)
        XCTAssertEqual(compiler.currentScope.lastInstruction?.code, .sub)
        XCTAssertEqual(compiler.symbolTable.outer, globalSymbolTable)
        compiler.leaveScope()
        XCTAssertEqual(compiler.scopeIndex, 0)
        XCTAssertEqual(compiler.symbolTable, globalSymbolTable)
        XCTAssertNil(compiler.symbolTable.outer)

        compiler.emit(.add)
        XCTAssertEqual(compiler.currentScope.instructions.count, 2)
        XCTAssertEqual(compiler.currentScope.lastInstruction?.code, .add)
        XCTAssertEqual(compiler.currentScope.prevInstruction?.code, .mul)
    }
}
