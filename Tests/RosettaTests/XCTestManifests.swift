import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(LexerTests.allTests),
        testCase(StringExtensionsTests.allTests)
    ]
}
#endif