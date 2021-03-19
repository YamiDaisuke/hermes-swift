//
//  BuiltinFunction.swift
//  MonkeyLang
//
//  Created by Franklin Cruz on 17-01-21.
//

import Foundation
import Rosetta

/// This is a wrapper for Monkey Language builtin functions
/// such as `len`
public struct BuiltinFunction: Object {
    /// Builtin functions will always receive an array of `Object` as arguments
    /// each function is responsible to validate the number and specific parameter
    /// types. The functions must return either nothing or another `Object`
    public typealias MonkeyFunction = ([Object]) throws -> Object?
    public var type: ObjectType { "Builtin" }

    var name: String
    var function: MonkeyFunction

    public init(name: String, _ function: @escaping MonkeyFunction) {
        self.name = name
        self.function = function
    }

    /// Currently not supported
    public func isEquals(other: Object) -> Bool {
        return false
    }

    public var description: String {
        "BuiltinFunction"
    }
}

/// An extension to define all available `BuiltinFunction` in Monkey language
/// for each availble function we must declare a static constant, append it to the `all`
/// array and add a new case into the string subscript 
extension BuiltinFunction {
    /// `len` function expects a single `MString`or an `MArray` parameter and
    /// will return the number of characters in that `MString` as `Integer`
    /// or the number of elements in the `MArray` as `Integer`
    static let len = BuiltinFunction(name: "len") { (args) throws -> Object? in
        guard args.count == 1 else {
            throw WrongArgumentCount(1, got: args.count)
        }

        if let string = args.first as? MString {
            return Integer(string.value.count)
        }

        if let array = args.first as? MArray {
            return Integer(array.elements.count)
        }

        throw InvalidArgumentType("String or Array", got: args.first?.type ?? "null")
    }

    /// `first` function expects a single `MArray` parameter and will return
    /// the element at index 0 of the given array or `null` if the array is empty
    static let first = BuiltinFunction(name: "first") { (args) throws -> Object? in
        guard args.count == 1 else {
            throw WrongArgumentCount(1, got: args.count)
        }

        guard let array = args.first as? MArray else {
            throw InvalidArgumentType("Array", got: args.first?.type ?? "null")
        }

        return array[Integer(0)]
    }

    /// `last` function expects a single `MArray` parameter and will return
    /// the element at index = `len(array) - 1`  of the given array or `null`
    /// if the array is empty
    static let last = BuiltinFunction(name: "last") { (args) throws -> Object? in
        guard args.count == 1 else {
            throw WrongArgumentCount(1, got: args.count)
        }

        guard let array = args.first as? MArray else {
            throw InvalidArgumentType("Array", got: args.first?.type ?? "null")
        }

        return array[Integer(array.elements.count - 1)]
    }

    /// `rest` function expects a single `MArray` parameter and will return
    ///  a new `MArray` with the elements from the original array starting from
    ///  index 1. If the array has only one element it will return an empty array.
    ///  If the array is empty it will return `null`
    static let rest = BuiltinFunction(name: "rest") { (args) throws -> Object? in
        guard args.count == 1 else {
            throw WrongArgumentCount(1, got: args.count)
        }

        guard let array = args.first as? MArray else {
            throw InvalidArgumentType("Array", got: args.first?.type ?? "null")
        }

        guard !array.elements.isEmpty else {
            return Null.null
        }

        guard array.elements.count > 1 else {
            return MArray(elements: [])
        }
        let newArray = Array(array.elements[1...])
        return MArray(elements: newArray)
    }

    /// `push` function expects an `MArray` parameter and one `Object` parameter
    /// it will return a new `MArray` instance with the same elements as the first parameter
    /// and the second paramter added at the end of the array
    static let push = BuiltinFunction(name: "push") { (args) throws -> Object? in
        guard args.count == 2 else {
            throw WrongArgumentCount(2, got: args.count)
        }

        guard let array = args.first as? MArray else {
            throw InvalidArgumentType("Array", got: args.first?.type ?? "null")
        }

        var newElements = array.elements
        newElements.append(args[1])
        return MArray(elements: newElements)
    }

    /// `puts` function takes any number or parameters and print them to the stdout
    /// one per each line. Returns `null`
    static let puts = BuiltinFunction(name: "puts") { (args) throws -> Object? in
        for arg in args {
            print(arg)
        }
        return Null.null
    }

    /// A list of all available functions
    static let all: [BuiltinFunction] = [
        .len,
        .puts,
        .first,
        .last,
        .rest,
        .push
    ]

    /// Get builtin functions using an index instead of a name, this is useful
    /// for the compiler and VM execution
    static subscript(index: Int) -> BuiltinFunction? {
        return all[index]
    }

    /// Here we map builtin functions with their respective indentifier
    /// if no function is found with the given name returns `nil`
    static subscript(name: String) -> BuiltinFunction? {
        switch name {
        case "len":
            return .len
        case "first":
            return .first
        case "last":
            return .last
        case "rest":
            return .rest
        case "push":
            return .push
        case "puts":
            return .puts
        default:
            return nil
        }
    }
}
