import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(MonkeyEvaluatorTests.allTests),
        testCase(MonkeyLexerTests.allTests),
        testCase(MonkeyParserExpressionTests.allTests),
        testCase(MonkeyParserStatementsTests.allTests)
    ]
}
#endif
