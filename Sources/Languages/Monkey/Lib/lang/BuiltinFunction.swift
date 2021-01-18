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

extension BuiltinFunction {
    /// `len` function expects a single `MString`or an `MArray` parameter and
    /// will return the number of characters in that `MString` as `Integer`
    /// or the number of elements in the `MArray` as `Integer`
    static let len = BuiltinFunction { (args) throws -> Object? in
        guard args.count == 1 else {
            throw WrongArgumentCount(1, got: args.count)
        }

        if let string = args.first as? MString {
            return Integer(value: string.value.count)
        }

        if let array = args.first as? MArray {
            return Integer(value: array.elements.count)
        }

        throw InvalidArgumentType("String or Array", got: args.first!.type)
    }

    /// `first` function expects a single `MArray` parameter and will return
    /// the element at index 0 of the given array or `null` if the array is empty
    static let first = BuiltinFunction { (args) throws -> Object? in
        guard args.count == 1 else {
            throw WrongArgumentCount(1, got: args.count)
        }

        guard let array = args.first as? MArray else {
            throw InvalidArgumentType("Array", got: args.first!.type)
        }

        return array[Integer(value: 0)]
    }

    /// `last` function expects a single `MArray` parameter and will return
    /// the element at index = `len(array) - 1`  of the given array or `null`
    /// if the array is empty
    static let last = BuiltinFunction { (args) throws -> Object? in
        guard args.count == 1 else {
            throw WrongArgumentCount(1, got: args.count)
        }

        guard let array = args.first as? MArray else {
            throw InvalidArgumentType("Array", got: args.first!.type)
        }

        return array[Integer(value: array.elements.count - 1)]
    }

    /// `rest` function expects a single `MArray` parameter and will return
    ///  a new `MArray` with the elements from the original array starting from
    ///  index 1. If the array has only one element it will return an empty array.
    ///  If the array is empty it will return `null`
    static let rest = BuiltinFunction { (args) throws -> Object? in
        guard args.count == 1 else {
            throw WrongArgumentCount(1, got: args.count)
        }

        guard let array = args.first as? MArray else {
            throw InvalidArgumentType("Array", got: args.first!.type)
        }

        guard array.elements.count > 0 else {
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
    static let push = BuiltinFunction { (args) throws -> Object? in
        guard args.count == 2 else {
            throw WrongArgumentCount(2, got: args.count)
        }

        guard let array = args.first as? MArray else {
            throw InvalidArgumentType("Array", got: args.first!.type)
        }

        var newElements = array.elements
        newElements.append(args[1])
        return MArray(elements: newElements)
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
            return push
        default:
            return nil
        }
    }
}
