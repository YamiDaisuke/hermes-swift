//
//  MonkeyExpressionParser.swift
//  MonkeyLang
//
//  Created by Franklin Cruz on 18-01-21.
//

import Foundation
import Rosetta

protocol MonkeyExpressionParser {

}

extension MonkeyExpressionParser {
    func parseExpressionList<P>(withEndDelimiter end: Token.Kind,
                                parser: inout P) throws -> [Expression] where P: Parser {
        var args: [Expression] = []

        guard parser.nextToken?.type != end else {
            parser.readToken()
            return args
        }

        parser.readToken()

        if let expression = try parser.parseExpression(withPrecedence: MonkeyPrecedence.lowest.rawValue) {
            args.append(expression)
        }

        while parser.nextToken?.type == .comma {
            parser.readToken()
            parser.readToken()
            if let expression = try parser.parseExpression(withPrecedence: MonkeyPrecedence.lowest.rawValue) {
                args.append(expression)
            }
        }

        try parser.expectNext(toBe: end)

        return args
    }
}
