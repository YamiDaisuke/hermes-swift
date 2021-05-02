//
//  MonkeyCompiler.swift
//  MonkeyLang
//
//  Created by Franklin Cruz on 01-02-21.
//

import Foundation
import Hermes

/// Monkey Lang compiler for the Hermes  VM
public struct MonkeyC: Compiler {
    public static var languageSignature: UInt32 = 1619651409

    public var scopes = [CompilationScope()]
    public var scopeIndex: Int = 0

    public typealias BaseType = Object

    public var constants: [VMBaseType] = []
    public var symbolTable: SymbolTable

    /// Creates a new symbol table including all available built in functions
    public static var newSymbolTable: SymbolTable {
        let symbolTable = SymbolTable()
        for index in 0..<BuiltinFunction.all.count {
            guard let function = BuiltinFunction[index] else { continue }
            do {
                try symbolTable.defineBuiltin(function.name, index: index)
            } catch {
                print("Can't define \(function.name)")
            }
        }

        return symbolTable
    }

    public init() {
        self.symbolTable = MonkeyC.newSymbolTable
    }

    /// Creates a compiler instance with an existing `SymbolTable`
    /// - Parameter table: The existing table
    public init(withSymbolTable table: SymbolTable) {
        self.symbolTable = table
    }

    public mutating func compile(_ program: Program) throws {
        for node in program.statements {
            try self.compile(node)
        }
    }

    public mutating func compile(_ node: Node) throws {
        do {
            switch node {
            case let expresion as ExpressionStatement:
                try self.compile(expresion.expression)
                self.emit(.pop)
            case let prefix as PrefixExpression:
                let operatorCode = try opCode(forPrefixOperator: prefix.operatorSymbol)
                try self.compile(prefix.rhs)
                self.emit(operatorCode)
            case let infix as InfixExpression:
                try self.handleInfixExpression(infix)
            case let condition as IfExpression:
                try self.handleIfExpression(condition)
            case let block as BlockStatement:
                for stmt in block.statements {
                    try self.compile(stmt)
                }
            case let integer as IntegerLiteral:
                let value = Integer(integer.value)
                self.emit(.constant, self.addConstant(value))
            case let float as FloatLiteral:
                let value = MFloat(float.value)
                self.emit(.constant, self.addConstant(value))
            case let string as StringLiteral:
                let value = MString(string.value)
                self.emit(.constant, self.addConstant(value))
            case let boolean as BooleanLiteral:
                self.emit(boolean.value ? .true : .false)
            case let array as ArrayLiteral:
                try self.handleArrayLiteral(array)
            case let hash as HashLiteral:
                try self.handleHashLiteral(hash)
            case let index as IndexExpression:
                try compile(index.lhs)
                try compile(index.index)

                self.emit(.index)
            case let declareStatement as DeclareStatement:
                try self.handleDeclareStatement(declareStatement)
            case let assignStatement as AssignStatement:
                try handleAssignStatement(assignStatement)
            case let identifier as Identifier:
                let symbol = try self.symbolTable.resolve(identifier.value)
                loadSymbol(symbol)
            case let function as FunctionLiteral:
                try self.handleFunctionLiterals(function)
            case let callExpression as CallExpression:
                try self.handleCallExpression(callExpression)
            case let returnStmt as ReturnStatement:
                try self.compile(returnStmt.value)
                self.emit(.returnVal)
            default:
                break
            }
        } catch var error as CompilerError {
            error.line = error.line ?? node.token.line
            error.column = error.column ?? node.token.column
            error.file = error.file ?? node.token.file
            throw error
        } catch {
            throw error
        }
    }

    /// Replace the last instruction if it is a OpPop operation
    /// - Parameter code: The replacement operation
    func replaceLastPopWith(_ code: OpCodes) {
        guard self.lastInstructionIs(.pop) else { return }

        guard let last = self.currentScope.lastInstruction?.position else { return }

        self.currentScope.replaceInstructionAt(last, with: Bytecode.make(code))
        self.currentScope.lastInstruction?.code = code
    }

    /// Converts an infix operator string representation to the corresponding `OpCode`
    /// - Parameter operatorStr: The operator string
    /// - Throws: `UnknownOperator` if the string does not match any `OpCode`
    /// - Returns: The `OpCode`
    func opCode(forInfixOperator operatorStr: String) throws -> OpCodes {
        switch operatorStr {
        case "+":
            return .add
        case "-":
            return .sub
        case "*":
            return .mul
        case "/":
            return .div
        case ">", "<":
            return .gt
        case ">=", "<=":
            return .gte
        case "==":
            return .equal
        case "!=":
            return .notEqual
        default:
            throw UnknownOperator(operatorStr)
        }
    }

    /// Converts an prefix operator string representation to the corresponding `OpCode`
    /// - Parameter operatorStr: The operator string
    /// - Throws: `UnknownOperator` if the string does not match any `OpCode`
    /// - Returns: The `OpCode`
    func opCode(forPrefixOperator operatorStr: String) throws -> OpCodes {
        switch operatorStr {
        case "-":
            return .minus
        case "!":
            return .bang
        default:
            throw UnknownOperator(operatorStr)
        }
    }

    // MARK: Helper Methods

    /// Handles the compilation of `InfixExpression`
    mutating func handleInfixExpression(_ expression: InfixExpression) throws {
        let operatorCode = try opCode(forInfixOperator: expression.operatorSymbol)

        if expression.operatorSymbol == "<=" || expression.operatorSymbol == "<" {
            try self.compile(expression.rhs)
            try self.compile(expression.lhs)
        } else {
            try self.compile(expression.lhs)
            try self.compile(expression.rhs)
        }

        self.emit(operatorCode)
    }

    /// Handles the compilation of `IfExpression`
    mutating func handleIfExpression(_ expression: IfExpression) throws {
        try self.compile(expression.condition)
        let jumpFPosition = self.emit(.jumpf, 9999)

        try self.compile(expression.consequence)
        self.currentScope.removeLast { $0.code == .pop }

        let jumpPosition = self.emit(.jump, 9999)
        let afterConsequence = self.currentInstructions.count
        self.replaceOperands(operands: [Int32(afterConsequence)], at: jumpFPosition)

        if let alternative = expression.alternative {
            try self.compile(alternative)
            self.currentScope.removeLast { $0.code == .pop }
        } else {
            self.emit(.null)
        }

        let afterAlternative = self.currentInstructions.count
        self.replaceOperands(operands: [Int32(afterAlternative)], at: jumpPosition)
    }

    /// Handles the compilation of `AssignStatement`
    mutating func handleAssignStatement(_ statement: AssignStatement) throws {
        try compile(statement.value)
        let symbol = try symbolTable.resolve(statement.name.value)

        guard symbol.type == .var else {
            throw AssignConstantError(statement.name.value)
        }

        let operation: OpCodes = symbol.scope == .global ? .assignGlobal : .assignLocal
        self.emit(operation, Int32(symbol.index))
    }

    /// Turns function literals into compiled functions
    mutating func handleFunctionLiterals(_ expression: FunctionLiteral) throws {
        self.enterScope()

        if let name = expression.name {
            try self.symbolTable.defineFunctionName(name)
        }

        for param in expression.params {
            try self.symbolTable.define(param.value)
        }

        try self.compile(expression.body)


        if self.lastInstructionIs(.pop) {
            self.replaceLastPopWith(.returnVal)
        }

        if !self.lastInstructionIs(.returnVal) {
            self.emit(.return)
        }

        let freeSymbols = self.symbolTable.freeSymbols
        let localsCount = self.symbolTable.totalDefinitions
        let instructions = self.leaveScope()

        for symbol in freeSymbols {
            self.loadSymbol(symbol)
        }

        let compiledFunction = CompiledFunction(
            instructions: instructions,
            localsCount: localsCount,
            parameterCount: expression.params.count
        )
        self.emit(.closure, self.addConstant(compiledFunction), Int32(freeSymbols.count))
    }

    /// Turns a call expression into VM operations
    mutating func handleCallExpression(_ expression: CallExpression) throws {
        try self.compile(expression.function)

        for arg in expression.args {
            try self.compile(arg)
        }

        self.emit(.call, Int32(expression.args.count))
    }

    /// Turns hash literals into VM operations
    mutating func handleHashLiteral(_ literal: HashLiteral) throws {
        let pairs = literal.pairs.sorted { $0.key.description < $1.key.description }

        for pair in pairs {
            try self.compile(pair.key)
            try self.compile(pair.value)
        }

        self.emit(.hash, Int32(pairs.count * 2))
    }

    /// Turns array literals into VM operations
    mutating func handleArrayLiteral(_ literal: ArrayLiteral) throws {
        for element in literal.elements {
            try self.compile(element)
        }

        self.emit(.array, Int32(literal.elements.count))
    }

    /// Turns variable or constant declaration into VM operations
    mutating func handleDeclareStatement(_ statement: DeclareStatement) throws {
        let type: VariableType = statement.token.type == .let ? .let : .var
        let symbol = try symbolTable.define(statement.name.value, type: type)
        try compile(statement.value)
        let operation: OpCodes = symbol.scope == .global ? .setGlobal : .setLocal
        self.emit(operation, Int32(symbol.index))
    }

    /// Loads the right operation for symbol load
    mutating func loadSymbol(_ symbol: Symbol) {
        switch symbol.scope {
        case .global:
            self.emit(.getGlobal, Int32(symbol.index))
        case .local:
            self.emit(.getLocal, Int32(symbol.index))
        case .builtin:
            self.emit(.getBuiltin, Int32(symbol.index))
        case .free:
            self.emit(.getFree, Int32(symbol.index))
        case .function:
            self.emit(.currentClosure)
        }
    }
}
