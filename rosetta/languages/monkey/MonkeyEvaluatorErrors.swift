//
//  MonkeyEvaluatorErrors.swift
//  rosetta
//
//  Created by Franklin Cruz on 13-01-21.
//

import Foundation

struct UnknownOperator: EvaluatorError {
    var message: String
    var line: Int?
    var column: Int?

    init(_ operatorSymbol: String, line: Int? = nil, column: Int? = nil) {
        self.message = "Unknown operator \"\(operatorSymbol)\""
        self.line = line
        self.column = column
    }
}

struct UnknownSyntaxToken: EvaluatorError {
    var message: String
    var line: Int?
    var column: Int?

    init(_ node: Node, line: Int? = nil, column: Int? = nil) {
        self.message = "Unknown token \"\(node)\""
        self.line = line
        self.column = column
    }
}

struct InvalidPrefixExpression: EvaluatorError {
    var message: String
    var line: Int?
    var column: Int?

    init(_ operatorSymbol: String, rhs: Object?, line: Int? = nil, column: Int? = nil) {
        self.message = "Can't apply operator \"\(operatorSymbol)\" to \(rhs?.type ?? "null")"
        self.line = line
        self.column = column
    }
}

struct InvalidInfixExpression: EvaluatorError {
    var message: String
    var line: Int?
    var column: Int?

    init(_ operatorSymbol: String, lhs: Object?, rhs: Object?, line: Int? = nil, column: Int? = nil) {
        self.message = "Can't apply operator \"\(operatorSymbol)\" to \(lhs?.type ?? "null") and \(rhs?.type ?? "null")"
        self.line = line
        self.column = column
    }
}
