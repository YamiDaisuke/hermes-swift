import XCTest

import MonkeyTests
import RosettaTests

var tests = [XCTestCaseEntry]()
tests += MonkeyTests.__allTests()
tests += RosettaTests.__allTests()

XCTMain(tests)
