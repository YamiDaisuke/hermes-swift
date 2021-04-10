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
    public static var type: ObjectType { "Array" }
    public var elements: [Object]

    /// Compare agaist other object
    ///
    /// To be consider equal `other` must be of type `MArray`, contains the same
    /// number of element and each value must be equal to the corresponding
    /// value in `other`
    /// - Parameter other: The other `Object`
    /// - Returns: `true` if `self` is equals to `other`
    public func isEquals(other: Object) -> Bool {
        guard let other = other as? MArray else {
            return false
        }

        guard self.elements.count == other.elements.count else {
            return false
        }

        for index in 0..<self.elements.count {
            if !self.elements[index].isEquals(other: other.elements[index]) {
                return false
            }
        }

        return true
    }

    public var description: String {
        "[\(elements.map { $0.description }.joined(separator: ", "))]"
    }

    /// Returns the element at postion `index` or `null` if the array is empty
    subscript(index: Integer) -> Object {
        get {
            guard index.value >= 0 && index.value < self.elements.count else {
                return Null.null
            }

            return elements[Int(index.value)]
        }
        set(newValue) {
            self.elements[Int(index.value)] = newValue
        }
    }
}
