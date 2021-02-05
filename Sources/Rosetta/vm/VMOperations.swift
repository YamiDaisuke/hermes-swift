//
//  VMOperations.swift
//  Rosetta
//
//  Created by Franklin Cruz on 04-02-21.
//

import Foundation

public protocol VMOperations {
    associatedtype BaseType
    func binaryOperation<BaseType>(lhs: BaseType, rhs: BaseType, operation: OpCodes) throws -> BaseType
}
