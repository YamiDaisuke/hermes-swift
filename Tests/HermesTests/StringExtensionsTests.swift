//
//  StringExtensionsTests.swift
//  rosettaTest
//
//  Created by Franklin Cruz on 29-12-20.
//

import XCTest
@testable import Hermes

class StringExtensionsTests: XCTestCase {
    func testIntSubscripts() throws {
        let myString = "my string for testing"

        let first = myString[0]
        XCTAssertEqual(first, "m")

        let second = myString[1]
        XCTAssertEqual(second, "y")

        var mySubstring = myString[0..<2]
        XCTAssertEqual(mySubstring, "my")
        mySubstring = myString[0...1]
        XCTAssertEqual(mySubstring, "my")

        let testing = myString[14...]
        XCTAssertEqual(testing, "testing")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
