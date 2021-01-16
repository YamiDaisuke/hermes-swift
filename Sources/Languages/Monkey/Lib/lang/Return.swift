//
//  Return.swift
//  MonkeyLang
//
//  Created by Franklin Cruz on 16-01-21.
//

import Foundation

/// Wrapper tto represent `return`, control transfer statement
public struct Return: Object {
    public var type: ObjectType { "return" }
    /// The returned value
    public var value: Object?

    public var description: String {
        "return \(value?.description ?? "null")"
    }
}
