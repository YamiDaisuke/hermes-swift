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
enum MonkeyTypes: UInt8, CustomStringConvertible {
    case null
    case integer
    case float
    case boolean
    case string
    case array
    case hash
    case function
    case `return`
    case builtin

    var bytes: [Byte] {
        return withUnsafeBytes(of: self.rawValue.bigEndian, [Byte].init)
    }

    var description: String {
        switch self {
        case .null:
            return Null.type
        case .integer:
            return Integer.type
        case .float:
            return MFloat.type
        case .boolean:
            return Boolean.type
        case .string:
            return MString.type
        case .array:
            return MArray.type
        case .hash:
            return Hash.type
        case .function:
            return Function.type
        case .return:
            return Return.type
        case .builtin:
            return BuiltinFunction.type
        }
    }
}

extension MonkeyTypes {
    public func decompile(fromBytes bytes: [Byte]) throws -> (value: Object?, readBytes: Int) {
        var value: Object?
        var readBytes = 0
        switch self {
        case .null:
            value = try Null(fromBytes: bytes, readBytes: &readBytes)
        case .integer:
            value = try Integer(fromBytes: bytes, readBytes: &readBytes)
        case .float:
            value = try MFloat(fromBytes: bytes, readBytes: &readBytes)
        case .boolean:
            value = try Boolean(fromBytes: bytes, readBytes: &readBytes)
        case .string:
            value = try MString(fromBytes: bytes, readBytes: &readBytes)
        case .array:
            value = try MArray(fromBytes: bytes, readBytes: &readBytes)
        case .hash:
            value = try Hash(fromBytes: bytes, readBytes: &readBytes)
        case .function:
            value = nil
        case .return:
            value = nil
        case .builtin:
            value = nil
        }

        return (value, readBytes)
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
    public init(fromBytes bytes: [Byte], readBytes: inout Int) throws {
        let type = UInt8(bytes.readInt(bytes: 1, startIndex: 0) ?? -1)

        if type != MonkeyTypes.null.rawValue {
            throw UnknowValueType(type.hexa)
        }

        self = Null.null
        readBytes = 1
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
    public init(fromBytes bytes: [Byte], readBytes: inout Int) throws {
        let type = UInt8(bytes.readInt(bytes: 1, startIndex: 0) ?? -1)

        if type != MonkeyTypes.integer.rawValue {
            throw UnknowValueType(type.hexa)
        }

        guard let decompiled = bytes.readInt(bytes: 4, startIndex: 1) else {
            throw CantDecompileValue(bytes, expectedType: Integer.type)
        }

        self.value = decompiled
        readBytes = 5 // 1 for type marker, 4 for Int32 value
    }
}

/// Allows an `MFloat` value to be compiled into Hermes bytecode
extension MFloat: Compilable {
    public func compile() -> [Byte] {
        let typeBytes = MonkeyTypes.float.bytes
        let valueBytes = withUnsafeBytes(of: self.value.bitPattern.bigEndian, [Byte].init)
        return typeBytes + valueBytes
    }
}

/// Allows an `MFloat` value to be decompiled from Hermes bytecode
extension MFloat: Decompilable {
    public init(fromBytes bytes: [Byte], readBytes: inout Int) throws {
        let type = UInt8(bytes.readInt(bytes: 1, startIndex: 0) ?? -1)

        if type != MonkeyTypes.float.rawValue {
            throw UnknowValueType(type.hexa)
        }


        let data = Data(bytes[1..<9])
        let bitPattern = UInt64(bigEndian: data.withUnsafeBytes { $0.load(as: UInt64.self) })
        let value = Float64(bitPattern: bitPattern)

        self.value = value
        readBytes = 1 + 8 // 1 for type marker, 8 for Float64 value
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
    public init(fromBytes bytes: [Byte], readBytes: inout Int) throws {
        let type = UInt8(bytes.readInt(bytes: 1, startIndex: 0) ?? -1)

        if type != MonkeyTypes.boolean.rawValue {
            throw UnknowValueType(type.hexa)
        }

        guard let decompiled = bytes.readInt(bytes: 1, startIndex: 1) else {
            throw CantDecompileValue(bytes, expectedType: Boolean.type)
        }

        self = decompiled == 1 ? Self.true : Self.false
        readBytes = 2
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
    public init(fromBytes bytes: [Byte], readBytes: inout Int) throws {
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

        readBytes = 1 + 4 + Int(size) // 1 for type marker, 4 for size Int32
    }
}

///

struct ValueIsNotCompilable: CompilerError {
    public var message: String
    public var line: Int?
    public var column: Int?
    public var file: String?

    public init(_ value: Any, line: Int? = nil, column: Int? = nil, file: String? = nil) {
        self.message = "Value \(value) is not Compilable"
        self.line = line
        self.column = column
        self.file = file
    }
}


/// Allows an `MArray` value to be compiled into Hermes bytecode
extension MArray: Compilable {
    public func compile() throws -> [Byte] {
        let typeBytes = MonkeyTypes.array.bytes
        var output = typeBytes

        let size = Int32(self.elements.count)
        let sizeBytes = withUnsafeBytes(
            of: size.bigEndian,
            [Byte].init
        )
        output += sizeBytes

        for element in self.elements {
            guard let compilable = element as? Compilable else {
                throw ValueIsNotCompilable(element)
            }

            output += try compilable.compile()
        }

        return output
    }
}

/// Allows an `MArray` value to be decompiled from Hermes bytecode
extension MArray: Decompilable {
    public init(fromBytes bytes: [Byte], readBytes: inout Int) throws {
        let type = UInt8(bytes.readInt(bytes: 1, startIndex: 0) ?? -1)

        if type != MonkeyTypes.array.rawValue {
            throw UnknowValueType(type.hexa)
        }

        let count = bytes.readInt(bytes: 4, startIndex: 1) ?? 0
        var elements: [Object] = []
        var readingBytes = 1 + 4
        for _ in 0..<count {
            guard let elementType =
                MonkeyTypes(rawValue: UInt8(bytes.readInt(bytes: 1, startIndex: readingBytes) ?? -1)) else {
                throw UnknowValueType(bytes[readingBytes..<(readingBytes + 1)].hexa)
            }

            let element = try elementType.decompile(fromBytes: Array(bytes[readingBytes...]))

            guard let value = element.value else {
                throw CantDecompileValue(bytes, expectedType: elementType.description)
            }

            elements.append(value)
            readingBytes += element.readBytes
        }

        self.elements = elements
        readBytes = readingBytes
    }
}

/// Allows an `Hash` value to be compiled into Hermes bytecode
extension Hash: Compilable {
    public func compile() throws -> [Byte] {
        let typeBytes = MonkeyTypes.hash.bytes
        var output = typeBytes

        let size = Int32(self.pairs.count)
        let sizeBytes = withUnsafeBytes(
            of: size.bigEndian,
            [Byte].init
        )
        output += sizeBytes

        for pair in self.pairs {
            guard let key = pair.key as? Compilable else {
                throw ValueIsNotCompilable(pair.key)
            }

            guard let value = pair.value as? Compilable else {
                throw ValueIsNotCompilable(pair.value)
            }

            output += try key.compile()
            output += try value.compile()
        }

        return output
    }
}

/// Allows an `Hash` value to be decompiled from Hermes bytecode
extension Hash: Decompilable {
    public init(fromBytes bytes: [Byte], readBytes: inout Int) throws {
        let type = UInt8(bytes.readInt(bytes: 1, startIndex: 0) ?? -1)

        if type != MonkeyTypes.hash.rawValue {
            throw UnknowValueType(type.hexa)
        }

        let count = bytes.readInt(bytes: 4, startIndex: 1) ?? 0
        var elements: [AnyHashable: Object] = [:]
        var readingBytes = 1 + 4
        for _ in 0..<count {
            guard let keyType =
                MonkeyTypes(rawValue: UInt8(bytes.readInt(bytes: 1, startIndex: readingBytes) ?? -1)) else {
                throw UnknowValueType(bytes[readingBytes..<(readingBytes + 1)].hexa)
            }

            let decompiledKey = try keyType.decompile(fromBytes: Array(bytes[readingBytes...]))

            guard let key = decompiledKey.value as? AnyHashable else {
                throw CantDecompileValue(bytes, expectedType: keyType.description)
            }

            readingBytes += decompiledKey.readBytes

            guard let valueType =
                MonkeyTypes(rawValue: UInt8(bytes.readInt(bytes: 1, startIndex: readingBytes) ?? -1)) else {
                throw UnknowValueType(bytes[readingBytes..<(readingBytes + 1)].hexa)
            }

            let decompiledValue = try valueType.decompile(fromBytes: Array(bytes[readingBytes...]))

            guard let value = decompiledValue.value else {
                throw CantDecompileValue(bytes, expectedType: valueType.description)
            }

            readingBytes += decompiledValue.readBytes

            elements[key] = value
        }

        self.pairs = elements
        readBytes = readingBytes
    }
}
