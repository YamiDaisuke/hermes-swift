import XCTest

import MonkeyTest

var tests = [XCTestCaseEntry]()
tests += MonkeyTest.allTests()
XCTMain(tests)
