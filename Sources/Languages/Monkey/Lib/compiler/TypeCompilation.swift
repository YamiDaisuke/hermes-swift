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
    case integer
}

/// Allows an `Integer` value to be compiled into Hermes bytecode
extension Integer: Compilable {
    public func compile() -> [Byte] {
        let typeBytes = withUnsafeBytes(of: MonkeyTypes.integer.rawValue.bigEndian, [Byte].init)
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
