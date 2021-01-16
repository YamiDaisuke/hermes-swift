import XCTest
import RosettaTest
import MonkeyTest

var tests = [XCTestCaseEntry]()
tests += RosettaTest.allTests()
tests += MonkeyTest.allTests()
XCTMain(tests)
