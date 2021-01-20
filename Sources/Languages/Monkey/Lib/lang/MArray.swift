//
//  MArray.swift
//  MonkeyLang
//
//  Created by Franklin Cruz on 17-01-21.
//

import Foundation

/// Monkey Language `Array` object, we have
/// to callit `MArray` to avoid colissions with swift
/// `Array`
public struct MArray: Object {
    public var type: ObjectType { "Array" }
    public var elements: [Object]

    public var description: String {
        "[\(elements.map { $0.description }.joined(separator: ", "))]"
    }

    /// Returns the element at postion `index` or `null` if the array is empty
    subscript(index: Integer) -> Object {
        get {
            guard index.value >= 0 && index.value < self.elements.count else {
                return Null.null
            }

            return elements[index.value]
        }
        set(newValue) {
            self.elements[index.value] = newValue
        }
    }
}
