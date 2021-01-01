//
//  StringExtensionsTests.swift
//  rosettaTest
//
//  Created by Franklin Cruz on 29-12-20.
//

import XCTest

class StringExtensionsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

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
