import XCTest

import HermesTests
import MonkeyTests

var tests = [XCTestCaseEntry]()
tests += HermesTests.__allTests()
tests += MonkeyTests.__allTests()

XCTMain(tests)
