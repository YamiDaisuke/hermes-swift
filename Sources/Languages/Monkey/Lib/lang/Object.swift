//
//  Object.swift
//  MonkeyLang
//
//  Created by Franklin Cruz on 16-01-21.
//

import Foundation

public typealias ObjectType = String

/// Base Type for all variables inside Monkey Language
/// think of this like the `Any` type of swift or `object`
/// type in C#
public protocol Object: CustomStringConvertible {
    var type: ObjectType { get }

    /// Compare agaist other object
    ///
    /// To avoid problems with the use of `Self` when implementing
    /// `Equatable` we use this approach.
    /// - Parameter other: Another Object instance
    func isEquals(other: Object) -> Bool
}
