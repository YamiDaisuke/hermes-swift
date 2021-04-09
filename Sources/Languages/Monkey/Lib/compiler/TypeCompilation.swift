//
//  TypeCompilation.swift
//  Hermes
//
//  Created by Franklin Cruz on 09-04-21.
//

import Foundation
import Hermes

enum MonkeyTypes: UInt32 {
    case integer
}

extension Integer: Compilable {
    public static var typeCode: UInt32 {
        return MonkeyTypes.integer.rawValue
    }

    public func compile() -> [Byte] {
        let typeBytes = withUnsafeBytes(of: Integer.typeCode.bigEndian, [Byte].init)
        let sizeBytes = withUnsafeBytes(of: Int32(32).bigEndian, [Byte].init)
        let valueBytes = withUnsafeBytes(of: self.value.bigEndian, [Byte].init)
        return typeBytes + sizeBytes + valueBytes
    }
}
