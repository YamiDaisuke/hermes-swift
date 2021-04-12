#if !canImport(ObjectiveC)
import XCTest

extension Benchmarks {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__Benchmarks = [
        ("testCompilerPerformance", testCompilerPerformance),
        ("testInterpreterPerformance", testInterpreterPerformance),
    ]
}

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

extension CompilableTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__CompilableTests = [
        ("testBooleanCompile", testBooleanCompile),
        ("testBooleanDecompile", testBooleanDecompile),
        ("testIntCompile", testIntCompile),
        ("testIntDecompile", testIntDecompile),
    ]
}

extension EvaluateOperationsTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__EvaluateOperationsTests = [
        ("testBangOperator", testBangOperator),
        ("testEvalBoolean", testEvalBoolean),
        ("testEvalFloat", testEvalFloat),
        ("testEvalFloatComparison", testEvalFloatComparison),
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
        ("testInvalidFloat", testInvalidFloat),
        ("testInvalidStrings", testInvalidStrings),
        ("testReadIdentifier", testReadIdentifier),
        ("testReadInteger", testReadInteger),
        ("testStrings", testStrings),
    ]
}

extension MonkeyCCollectionsTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MonkeyCCollectionsTests = [
        ("testArrayLiterals", testArrayLiterals),
        ("testHashLiterals", testHashLiterals),
        ("testIndexExpressions", testIndexExpressions),
    ]
}

extension MonkeyCErrorTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MonkeyCErrorTests = [
        ("testErrors", testErrors),
    ]
}

extension MonkeyCFunctionsTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MonkeyCFunctionsTests = [
        ("testBuiltins", testBuiltins),
        ("testClosures", testClosures),
        ("testFunctionCalls", testFunctionCalls),
        ("testFunctions", testFunctions),
        ("testRecursiveFunction", testRecursiveFunction),
    ]
}

extension MonkeyCScopesTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MonkeyCScopesTests = [
        ("testAssigmentScopes", testAssigmentScopes),
        ("testLetStatementsScopes", testLetStatementsScopes),
        ("testRedeclarionScopes", testRedeclarionScopes),
        ("testVarStatementsScopes", testVarStatementsScopes),
    ]
}

extension MonkeyCompilerTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MonkeyCompilerTests = [
        ("testBooleanExpressions", testBooleanExpressions),
        ("testConditionals", testConditionals),
        ("testFloats", testFloats),
        ("testGlobalLetStatements", testGlobalLetStatements),
        ("testGlobalVarStatements", testGlobalVarStatements),
        ("testIntegerArithmetic", testIntegerArithmetic),
        ("testStringExpressions", testStringExpressions),
    ]
}

extension MonkeyEvaluatorTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MonkeyEvaluatorTests = [
        ("testArrayIndexExpression", testArrayIndexExpression),
        ("testArrayLiteral", testArrayLiteral),
        ("testAssignStatement", testAssignStatement),
        ("testClousure", testClousure),
        ("testDeclareStatement", testDeclareStatement),
        ("testEvalComments", testEvalComments),
        ("testEvalStrings", testEvalStrings),
        ("testEvaluatorErrors", testEvaluatorErrors),
        ("testFunctionCall", testFunctionCall),
        ("testFunctionObject", testFunctionObject),
        ("testHashIndexExpressions", testHashIndexExpressions),
        ("testHashLiteral", testHashLiteral),
        ("testIfElseExpression", testIfElseExpression),
        ("testReturnStatement", testReturnStatement),
    ]
}

extension MonkeyLexerTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MonkeyLexerTests = [
        ("testNextToken", testNextToken),
        ("testNextTokenFromFile", testNextTokenFromFile),
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
        ("testParseAssignStatement", testParseAssignStatement),
        ("testParseLetStatement", testParseLetStatement),
        ("testParseLetStatementErrors", testParseLetStatementErrors),
        ("testParseVarStatement", testParseVarStatement),
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
        ("testComments", testComments),
        ("testFloatLiteralExpression", testFloatLiteralExpression),
        ("testFunctionLiteral", testFunctionLiteral),
        ("testFunctionLiteralWithName", testFunctionLiteralWithName),
        ("testIntLiteralExpression", testIntLiteralExpression),
        ("testStringLiteralExpression", testStringLiteralExpression),
    ]
}

extension VMCollectionsTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__VMCollectionsTests = [
        ("testArrayLiterals", testArrayLiterals),
        ("testHashLiterals", testHashLiterals),
        ("testIndexExpressions", testIndexExpressions),
    ]
}

extension VMFunctionTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__VMFunctionTests = [
        ("testBuiltinFunctions", testBuiltinFunctions),
        ("testCallFunctionsWithArgumentsBindings", testCallFunctionsWithArgumentsBindings),
        ("testCallFunctionsWithBindings", testCallFunctionsWithBindings),
        ("testCallFunctionsWithoutArgumentsBindings", testCallFunctionsWithoutArgumentsBindings),
        ("testCallingFunctionsWithoutArguments", testCallingFunctionsWithoutArguments),
        ("testCallingFunctionsWithoutReturnValue", testCallingFunctionsWithoutReturnValue),
        ("testCallingFunctionsWithReturnStatement", testCallingFunctionsWithReturnStatement),
        ("testClosures", testClosures),
        ("testFirstClassFunctions", testFirstClassFunctions),
        ("testRecursiveFunctions", testRecursiveFunctions),
    ]
}

extension VMTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__VMTests = [
        ("testBooleanExpressions", testBooleanExpressions),
        ("testConditionals", testConditionals),
        ("testFloatExpressions", testFloatExpressions),
        ("testGlobalLetStatements", testGlobalLetStatements),
        ("testGlobalVarStatements", testGlobalVarStatements),
        ("testIntegerArithmetic", testIntegerArithmetic),
        ("testStringExpressions", testStringExpressions),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Benchmarks.__allTests__Benchmarks),
        testCase(BuiltinFunctionsTests.__allTests__BuiltinFunctionsTests),
        testCase(CompilableTests.__allTests__CompilableTests),
        testCase(EvaluateOperationsTests.__allTests__EvaluateOperationsTests),
        testCase(LexerTypesTests.__allTests__LexerTypesTests),
        testCase(MonkeyCCollectionsTests.__allTests__MonkeyCCollectionsTests),
        testCase(MonkeyCErrorTests.__allTests__MonkeyCErrorTests),
        testCase(MonkeyCFunctionsTests.__allTests__MonkeyCFunctionsTests),
        testCase(MonkeyCScopesTests.__allTests__MonkeyCScopesTests),
        testCase(MonkeyCompilerTests.__allTests__MonkeyCompilerTests),
        testCase(MonkeyEvaluatorTests.__allTests__MonkeyEvaluatorTests),
        testCase(MonkeyLexerTests.__allTests__MonkeyLexerTests),
        testCase(MonkeyParserExpressionTests.__allTests__MonkeyParserExpressionTests),
        testCase(MonkeyParserStatementsTests.__allTests__MonkeyParserStatementsTests),
        testCase(ParseHashLiteralsTests.__allTests__ParseHashLiteralsTests),
        testCase(ParseLiteralsTests.__allTests__ParseLiteralsTests),
        testCase(VMCollectionsTests.__allTests__VMCollectionsTests),
        testCase(VMFunctionTests.__allTests__VMFunctionTests),
        testCase(VMTests.__allTests__VMTests),
    ]
}
#endif
