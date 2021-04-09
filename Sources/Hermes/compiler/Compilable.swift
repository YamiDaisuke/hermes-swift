//
//  Compilable.swift
//  Hermes
//
//  Created by Franklin Cruz on 09-04-21.
//

import Foundation

/// Marks a value that can be converted into Hermes byte representation
public protocol Compilable {
    /// A mark to indicate which type use this bytes belongs to
    static var typeCode: UInt32 { get }

    /// Retunrs a byte array representing this value in the format:
    /// `[<type code bytes:4>,<size bytes: 4>, <value bytes>]`
    func compile() -> [Byte]
}

/// Marks a value that can be converted from a Hermes byte representation
public protocol Decompilable {
    init(fromBytes bytes: [Byte])
}

/// Utility to print a byte array as a hex string
extension Sequence where Element == Byte {
    var hexa: String { map { .init(format: "%02x", $0) }.joined(separator: " ") }
}

/// Utility to print a UInt32 into a hex string
extension UInt32 {
    var hexa: String {
        let bytes = withUnsafeBytes(of: self.bigEndian, [Byte].init)
        return bytes.hexa
    }
}
