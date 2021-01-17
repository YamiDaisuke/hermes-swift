//
//  BuiltinFunction.swift
//  MonkeyLang
//
//  Created by Franklin Cruz on 17-01-21.
//

import Foundation

/// This is a wrapper for Monkey Language builtin functions
/// such as `len`
public struct BuiltinFunction: Object {
    /// Builtin functions will always receive an array of `Object` as arguments
    /// each function is responsible to validate the number and specific parameter
    /// types. The functions must return either nothing or another `Object`
    public typealias MonkeyFunction = ([Object]) throws -> Object?
    public var type: ObjectType { "Builtin" }

    var function: MonkeyFunction

    public init(_ function: @escaping MonkeyFunction) {
        self.function = function
    }

    public var description: String {
        "BuiltinFunction"
    }
}
