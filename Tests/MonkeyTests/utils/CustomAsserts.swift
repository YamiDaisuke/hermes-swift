//
//  File.swift
//  MonkeyTests
//
//  Created by Franklin Cruz on 18-01-21.
//

import XCTest
@testable import Hermes
@testable import MonkeyLang

// MARK: - Assert Evaluator

func MKAssertInteger(object: Object?, expected: Int, file: StaticString = #file, line: UInt = #line) {
    let integer = object as? Integer
    XCTAssertNotNil(integer, file: file, line: line)
    XCTAssertEqual(integer?.value, expected, file: file, line: line)
}

func MKAssertFloat(object: Object?, expected: Float64, file: StaticString = #file, line: UInt = #line) {
    let float = object as? MFloat
    XCTAssertNotNil(float, file: file, line: line)
    XCTAssertEqual(float?.value, expected, file: file, line: line)
}

func MKAssertBoolean(object: Object?, expected: Bool, file: StaticString = #file, line: UInt = #line) {
    let bool = object as? Boolean
    XCTAssertNotNil(bool, file: file, line: line)
    XCTAssertEqual(bool?.value, expected, file: file, line: line)
}

// MARK: - Assert Parser

func MKAssertInfixExpression(
    expression: Expression?,
    lhs: String,
    operatorSymbol: String,
    rhs: String,
    file: StaticString = #file,
    line: UInt = #line
) {
    let infix = expression as? InfixExpression
    XCTAssertNotNil(infix, file: file, line: line)
    XCTAssertEqual(infix?.lhs.literal, lhs, file: file, line: line)
    XCTAssertEqual(infix?.operatorSymbol, operatorSymbol, file: file, line: line)
    XCTAssertEqual(infix?.rhs.literal, rhs, file: file, line: line)
}

func MKAssertIntegerLiteral(expression: Expression?, expected: Int, file: StaticString = #file, line: UInt = #line) {
    let integer = expression as? IntegerLiteral
    XCTAssertNotNil(integer, file: file, line: line)
    XCTAssertEqual(integer?.value, expected, file: file, line: line)
    XCTAssertEqual(integer?.literal, expected.description, file: file, line: line)
}

func MKAssertFloatLiteral(expression: Expression?, expected: Float64, file: StaticString = #file, line: UInt = #line) {
    let float = expression as? FloatLiteral
    XCTAssertNotNil(float, file: file, line: line)
    XCTAssertEqual(float?.value, expected, file: file, line: line)
    XCTAssertEqual(float?.literal, expected.description, file: file, line: line)
}

func MKAssertBoolLiteral(expression: Expression?, expected: Bool, file: StaticString = #file, line: UInt = #line) {
    let boolean = expression as? BooleanLiteral
    XCTAssertNotNil(boolean, file: file, line: line)
    XCTAssertEqual(boolean?.value, expected, file: file, line: line)
    XCTAssertEqual(boolean?.literal, expected.description, file: file, line: line)
}

func MKAssertIdentifier(expression: Expression?, expected: String, file: StaticString = #file, line: UInt = #line) {
    let identifier = expression as? Identifier
    XCTAssertNotNil(identifier, file: file, line: line)
    XCTAssertEqual(identifier?.value, expected, file: file, line: line)
    XCTAssertEqual(identifier?.literal, expected, file: file, line: line)
}

// MARK: - Assert Compiler

func MKAssertInstructions(
    _ instructions: Instructions,
    _ expected: [Instructions],
    file: StaticString = #file,
    line: UInt = #line
) {
    let expectedConcat = Instructions(expected.joined())
    print("--- Compiled ---")
    print(instructions.description)
    print("--- Expected ---")
    print(expectedConcat.description)
    print("------ End -----")
    XCTAssertEqual(instructions.count, expectedConcat.count, file: file, line: line)
    XCTAssertEqual(instructions, expectedConcat, file: file, line: line)
}

func MKAssertConstants(
    _ emitted: [VMBaseType],
    _ expected: [VMBaseType],
    file: StaticString = #file,
    line: UInt = #line
) {
    XCTAssertEqual(emitted.count, expected.count, file: file, line: line)
    for index in 0..<emitted.count {
        let value = emitted[index] as? Object
        XCTAssertNotNil(value)
        XCTAssert(
            value?.isEquals(other: expected[index] as? Object ?? Null.null) ?? false,
            file: file,
            line: line
        )
    }
}
