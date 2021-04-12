//
//  TypeCompilation.swift
//  Hermes
//
//  Created by Franklin Cruz on 09-04-21.
//

import Foundation
import Hermes

/// Matches each Monkey lang type to a byte code
/// that represent them in Hermes bytecode
enum MonkeyTypes: UInt8 {
    case null
    case integer
    case boolean
    case string

    var bytes: [Byte] {
        return withUnsafeBytes(of: self.rawValue.bigEndian, [Byte].init)
    }
}

/// Allows an `Null` value to be compiled into Hermes bytecode
extension Null: Compilable {
    public func compile() -> [Byte] {
        let typeBytes = MonkeyTypes.null.bytes
        return typeBytes
    }
}

/// Allows an `Null` value to be decompiled from Hermes bytecode
extension Null: Decompilable {
    public init(fromBytes bytes: [Byte]) throws {
        let type = UInt8(bytes.readInt(bytes: 1, startIndex: 0) ?? -1)

        if type != MonkeyTypes.null.rawValue {
            throw UnknowValueType(type.hexa)
        }

        self = Null.null
    }
}

/// Allows an `Integer` value to be compiled into Hermes bytecode
extension Integer: Compilable {
    public func compile() -> [Byte] {
        let typeBytes = MonkeyTypes.integer.bytes
        let valueBytes = withUnsafeBytes(of: self.value.bigEndian, [Byte].init)
        return typeBytes + valueBytes
    }
}

/// Allows an `Integer` value to be decompiled from Hermes bytecode
extension Integer: Decompilable {
    public init(fromBytes bytes: [Byte]) throws {
        let type = UInt8(bytes.readInt(bytes: 1, startIndex: 0) ?? -1)

        if type != MonkeyTypes.integer.rawValue {
            throw UnknowValueType(type.hexa)
        }

        guard let decompiled = bytes.readInt(bytes: 4, startIndex: 1) else {
            throw CantDecompileValue(bytes, expectedType: Integer.type)
        }

        self.value = decompiled
    }
}

/// Allows an `Boolean` value to be compiled into Hermes bytecode
extension Boolean: Compilable {
    public func compile() -> [Byte] {
        let typeBytes = MonkeyTypes.boolean.bytes
        let valueBytes = withUnsafeBytes(
            of: self.value ? UInt8(1).bigEndian : UInt8(0).bigEndian,
            [Byte].init
        )
        return typeBytes + valueBytes
    }
}

/// Allows an `Integer` value to be decompiled from Hermes bytecode
extension Boolean: Decompilable {
    public init(fromBytes bytes: [Byte]) throws {
        let type = UInt8(bytes.readInt(bytes: 1, startIndex: 0) ?? -1)

        if type != MonkeyTypes.boolean.rawValue {
            throw UnknowValueType(type.hexa)
        }

        guard let decompiled = bytes.readInt(bytes: 1, startIndex: 1) else {
            throw CantDecompileValue(bytes, expectedType: Boolean.type)
        }

        self = decompiled == 1 ? Self.true : Self.false
    }
}

/// Allows an `MString` value to be compiled into Hermes bytecode
extension MString: Compilable {
    public func compile() -> [Byte] {
        let typeBytes = MonkeyTypes.string.bytes
        /// TODO: Enforce this max value when a MString is allocated
        let size = Int32(self.value.lengthOfBytes(using: .utf8))
        let sizeBytes = withUnsafeBytes(
            of: size.bigEndian,
            [Byte].init
        )
        var output = typeBytes + sizeBytes
        for char in self.value.utf8 {
            output += withUnsafeBytes(
                of: char.bigEndian,
                [Byte].init
            )
        }
        return output
    }
}

/// Allows an `MString` value to be decompiled from Hermes bytecode
extension MString: Decompilable {
    public init(fromBytes bytes: [Byte]) throws {
        let type = UInt8(bytes.readInt(bytes: 1, startIndex: 0) ?? -1)

        if type != MonkeyTypes.string.rawValue {
            throw UnknowValueType(type.hexa)
        }

        guard let size = bytes.readInt(bytes: 4, startIndex: 1) else {
            throw CantDecompileValue(bytes, expectedType: MString.type)
        }

        guard let value = String(bytes: bytes[5..<(Int(size) + 5)], encoding: .utf8) else {
            throw CantDecompileValue(bytes, expectedType: MString.type)
        }

        self.value = value
    }
}
