//
//  main.swift
//  rossetta
//
//  Created by Franklin Cruz on 27-12-20.
//

import Foundation
import Hermes
import HermesREPL
import MonkeyLang
import TSCUtility
import TSCBasic

/// Compiles a Monkey language code file into bytecode
/// expects a text file with mky extension
/// - Parameter filepath: The file to compile
/// - Throws: An error if the file can't be compiled, parsed or read
func compile(_ filepath: Foundation.URL) throws {
    let lexer = MonkeyLexer(withFilePath: filepath)
    var parser = MonkeyParser(lexer: lexer)
    let program = try parser.parseProgram() ?? Program(statements: [])
    var compiler = MonkeyC()

    try compiler.compile(program)
    let output = URL(fileURLWithPath: "./\(filepath.deletingPathExtension().lastPathComponent).mkc")
    compiler.writeToFile(output)
}

/// Runs a Monkey language using the interpreter
/// expects a text file with mky extension
/// - Parameter filepath: The file to execute
/// - Throws: An error if the file can't be parsed, read or generates a runtime error
func interpret(_ filepath: Foundation.URL) throws {
    let environment = Environment<Object>()
    let lexer = MonkeyLexer(withFilePath: filepath)
    var monkeyParser = MonkeyParser(lexer: lexer)

    if let program = try monkeyParser.parseProgram() {
        _ = try MonkeyEvaluator.eval(program: program, environment: environment)
    } else {
        throw "Program not parsed"
    }
}

/// Execute a compiled Monkey language file, this file must have been compiled with
/// a compatible version of Hermes bytecode
/// - Parameter filepath: The file to execute
/// - Throws: An error if the file contains invalid binary code or generates a runtime error
func execute(_ filepath: Foundation.URL) throws {
    var vm = try VM(filepath, operations: MonkeyVMOperations())
    try vm.run()
}

/// Dumps a string representation of a Monkey language binary file, this file must have been compiled with
/// a compatible version of Hermes bytecode
/// - Parameter filepath: The file to execute
/// - Throws: An error if the file contains invalid binary code or generates a runtime error
func dump(_ filepath: Foundation.URL) throws {
    let vm = try VM(filepath, operations: MonkeyVMOperations())
    print(vm.dump())
}

/// Starts a Monkey language REPL in interpreter or compiler mode
/// - Parameter mode: The mode to use for the REPL. Default: `interpreter`
func repl(_ mode: ReplMode = .interpreter) {
    var repl = MonkeyRepl(mode: mode)
    repl.run()
}

do {
    let parser = ArgumentParser(
        commandName: "monkey",
        usage: "[target_file] -m [interpreter|compiler]",
        overview: "The marvelous Monkey REPL, Interpreter and Compiler!"
    )

    let mode = parser.add(
        option: "--mode",
        shortName: "-m",
        kind: ReplMode.self,
        usage: """
        Switch between "compiler" and "interpreter" mode.
        For REPL the default mode is "interpreter", for a file is "compiler"
        """
    )

    let filename = parser.add(
        positional: "file",
        kind: String.self,
        optional: true,
        usage: "A file with Monkey code to be interpreted, compiled or executed",
        completion: ShellCompletion.filename
    )

    let dumpArg = parser.add(
        option: "--dump",
        shortName: "-d",
        kind: Bool.self,
        usage: "Pass this flag to dump a compiled file as bytecode instead on runing it"
    )

    let argsv = Array(CommandLine.arguments.dropFirst())
    let parguments = try parser.parse(argsv)

    if let filename = parguments.get(filename) {
        let filepath = URL(fileURLWithPath: filename)
        let selectedMode = parguments.get(mode) ?? .compiler

        if filepath.pathExtension == "mky" {
            if selectedMode == .compiler {
                try compile(filepath)
            } else {
                try interpret(filepath)
            }
        } else if filepath.pathExtension == "mkc" || filepath.pathExtension.isEmpty {
            if parguments.get(dumpArg) ?? false {
                try dump(filepath)
            } else {
                try execute(filepath)
            }
        } else {
            throw "Unknow file type: \(filepath.standardizedFileURL)"
        }
    } else {
        let selectedMode = parguments.get(mode) ?? .interpreter
        repl(selectedMode)
    }
} catch let ArgumentParserError.expectedValue(value) {
    TerminalController.printError("Missing value for argument \(value).")
} catch let ArgumentParserError.expectedArguments(parser, stringArray) {
    TerminalController.printError("Parser: \(parser) Missing arguments: \(stringArray.joined()).")
} catch {
    TerminalController.printError(error)
}
