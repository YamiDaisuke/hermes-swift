//
//  File.swift
//  MonkeyTests
//
//  Created by Franklin Cruz on 18-01-21.
//

import XCTest
@testable import Rosetta
@testable import MonkeyLang

func MKAssertInteger(object: Object?, expected: Int, file: StaticString = #file, line: UInt = #line) {
    let integer = object as? Integer
    XCTAssertNotNil(integer, file: file, line: line)
    XCTAssertEqual(integer?.value, expected, file: file, line: line)
}

func MKAssertBoolean(object: Object?, expected: Bool, file: StaticString = #file, line: UInt = #line) {
    let bool = object as? Boolean
    XCTAssertNotNil(bool, file: file, line: line)
    XCTAssertEqual(bool?.value, expected, file: file, line: line)
}

func MKAssertInfixExpression(expression: Expression?,
                             lhs: String,
                             operatorSymbol: String,
                             rhs: String,
                             file: StaticString = #file,
                             line: UInt = #line) {
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
