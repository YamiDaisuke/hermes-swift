#if !canImport(ObjectiveC)
import XCTest

extension BuiltinFunctionsTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__BuiltinFunctionsTests = [
        ("testFirstFunction", testFirstFunction),
        ("testLastFunction", testLastFunction),
        ("testLenFunction", testLenFunction),
        ("testPushFunction", testPushFunction),
        ("testRestFunction", testRestFunction),
    ]
}

extension EvaluateOperationsTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__EvaluateOperationsTests = [
        ("testBangOperator", testBangOperator),
        ("testEvalBoolean", testEvalBoolean),
        ("testEvalInteger", testEvalInteger),
        ("testEvalStringCompare", testEvalStringCompare),
        ("testEvalStringConcatention", testEvalStringConcatention),
    ]
}

extension LexerTypesTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__LexerTypesTests = [
        ("testInvalidStrings", testInvalidStrings),
        ("testReadIdentifier", testReadIdentifier),
        ("testReadInteger", testReadInteger),
        ("testStrings", testStrings),
    ]
}

extension MonkeyEvaluatorTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MonkeyEvaluatorTests = [
        ("testArrayIndexExpression", testArrayIndexExpression),
        ("testArrayLiteral", testArrayLiteral),
        ("testClousure", testClousure),
        ("testEvalStrings", testEvalStrings),
        ("testEvaluatorErrors", testEvaluatorErrors),
        ("testFunctionCall", testFunctionCall),
        ("testFunctionObject", testFunctionObject),
        ("testIfElseExpression", testIfElseExpression),
        ("testLetStatement", testLetStatement),
        ("testReturnStatement", testReturnStatement),
    ]
}

extension MonkeyLexerTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MonkeyLexerTests = [
        ("testNextToken", testNextToken),
        ("testNextTokenWithLineNumber", testNextTokenWithLineNumber),
    ]
}

extension MonkeyParserExpressionTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MonkeyParserExpressionTests = [
        ("testCallExpression", testCallExpression),
        ("testExpressions", testExpressions),
        ("testIdentifierExpression", testIdentifierExpression),
        ("testIfElseExpression", testIfElseExpression),
        ("testIfExpression", testIfExpression),
        ("testInfixExpressions", testInfixExpressions),
        ("testParsingIndexExpressions", testParsingIndexExpressions),
        ("testPrefixExpressions", testPrefixExpressions),
    ]
}

extension MonkeyParserStatementsTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MonkeyParserStatementsTests = [
        ("testParseLetStatement", testParseLetStatement),
        ("testParseLetStatementErrors", testParseLetStatementErrors),
        ("testReturnStatement", testReturnStatement),
    ]
}

extension ParseHashLiteralsTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ParseHashLiteralsTests = [
        ("testParsingEmptyHashLiteral", testParsingEmptyHashLiteral),
        ("testParsingHashLiteralWithBooleanKeys", testParsingHashLiteralWithBooleanKeys),
        ("testParsingHashLiteralWithIntegerKeys", testParsingHashLiteralWithIntegerKeys),
        ("testParsingHashLiteralWithStringKeys", testParsingHashLiteralWithStringKeys),
    ]
}

extension ParseLiteralsTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ParseLiteralsTests = [
        ("testArrayLiteral", testArrayLiteral),
        ("testBooleanLiteralExpression", testBooleanLiteralExpression),
        ("testFunctionLiteral", testFunctionLiteral),
        ("testIntLiteralExpression", testIntLiteralExpression),
        ("testStringLiteralExpression", testStringLiteralExpression),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(BuiltinFunctionsTests.__allTests__BuiltinFunctionsTests),
        testCase(EvaluateOperationsTests.__allTests__EvaluateOperationsTests),
        testCase(LexerTypesTests.__allTests__LexerTypesTests),
        testCase(MonkeyEvaluatorTests.__allTests__MonkeyEvaluatorTests),
        testCase(MonkeyLexerTests.__allTests__MonkeyLexerTests),
        testCase(MonkeyParserExpressionTests.__allTests__MonkeyParserExpressionTests),
        testCase(MonkeyParserStatementsTests.__allTests__MonkeyParserStatementsTests),
        testCase(ParseHashLiteralsTests.__allTests__ParseHashLiteralsTests),
        testCase(ParseLiteralsTests.__allTests__ParseLiteralsTests),
    ]
}
#endif
