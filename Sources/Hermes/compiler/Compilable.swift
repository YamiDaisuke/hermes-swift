//
//  Compilable.swift
//  Hermes
//
//  Created by Franklin Cruz on 09-04-21.
//

import Foundation

/// Marks a value that can be converted into Hermes byte representation
public protocol Compilable {
    /// Retunrs a byte array representing this value in a format like the following:
    /// `[<type code bytes:4>,<size bytes: 4>, <value bytes>]`
    /// Some types might not required an explicit size so this section can be omited
    /// but we always need a type code byte set 
    /// TODO: Work with bits for small memory foot print
    func compile() throws -> [Byte]
}

/// Marks a value that can be converted from a Hermes byte representation
public protocol Decompilable {
    init(fromBytes bytes: [Byte]) throws
    init(fromBytes bytes: [Byte], readBytes: inout Int) throws
}

public extension Decompilable {
    init(fromBytes bytes: [Byte]) throws {
        var discard = 0
        try self.init(fromBytes: bytes, readBytes: &discard)
    }
}

/// Throw this if the first bytes of a compiled value does not match
/// a type supported by the language
public struct UnknowValueType: CompilerError {
    public var message: String
    public var line: Int?
    public var column: Int?
    public var file: String?

    public init(_ type: String, line: Int? = nil, column: Int? = nil, file: String? = nil) {
        self.message = "Unknow value type: \(type)"
        self.line = line
        self.column = column
        self.file = file
    }
}

/// Throw this if the bytes fail to be decompiled into the expected type
public struct CantDecompileValue: CompilerError {
    public var message: String
    public var line: Int?
    public var column: Int?
    public var file: String?

    public init(_ bytes: [Byte], expectedType: String, line: Int? = nil, column: Int? = nil, file: String? = nil) {
        self.message = "Can't decompile \(expectedType) from bytes: \(bytes.hexa)"
        self.line = line
        self.column = column
        self.file = file
    }
}

/// Utility to print a byte array as a hex string
extension Sequence where Element == Byte {
    public var hexa: String { map { .init(format: "%02x", $0) }.joined(separator: " ") }
}

/// Utility to print a UInt32 into a hex string
extension FixedWidthInteger {
    public var hexa: String {
        let bytes = withUnsafeBytes(of: self.bigEndian, [Byte].init)
        return bytes.hexa
    }
}
