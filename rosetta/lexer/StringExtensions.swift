//
//  StringExtensions.swift
//  rosetta
//
//  Created by Franklin Cruz on 28-12-20.
//

import Foundation

extension String {
    /// Returns `true` if this `String` contains only characters consider
    /// a valid letter for identifiers
    public var isLetter: Bool {
        self ~= "[a-zA-Z_]"
    }
}

extension Character {
    /// Returns `true` if this `Character` contains only characters consider
    /// a valid letter for identifiers
    public var isIdentifierLetter: Bool {
        return self.isLetter || self == "_"
    }
}

extension String {
    /// Compares a `String` against another string containing a regular expression
    ///
    /// - Parameters:
    ///   - lhs: The `String` to match
    ///   - rhs: A `String` containing a valid regular expression to match againts `lhs`
    /// - Returns: `true` if `lhs` matches the regular expression in `rhs` or `false` otherwise
    static func ~= (lhs: String, rhs: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: rhs) else { return false }
        let range = NSRange(location: 0, length: lhs.utf16.count)
        return regex.firstMatch(in: lhs, options: [], range: range) != nil
    }
}

extension String {
    
    /// This is a utility `subscript` to make string manipulation les cumbersome
    /// it will work the same way as the current `String` `subscript` but
    /// using an `Int` index and mapping it to the right `Index` value
    ///
    /// - Parameter index: An `Int` expected to be greater than or equal to zero
    ///   and less than `self.count`
    subscript(index: Int) -> Character {
        self[self.index(self.startIndex, offsetBy: index)]
    }
    
    /// This is a utility `subscript` to make string manipulation les cumbersome
    /// it will work the same way as the current `String` `subscript` but
    /// using an `RangeExpression<Int>` index and mapping it to the right `RangeExpression<Index>` value
    ///
    /// - Parameter range: An `RangeExpression` of `Int` values expected to be
    ///   contained inside the bounds of this string
    subscript<R>(range: R) -> String.SubSequence where R: RangeExpression, R.Bound == Int {
        let r = range.relative(to: Array<Bool>(repeating: false, count: self.count))
        let start = self.index(self.startIndex, offsetBy: r.startIndex)
        let end = self.index(self.startIndex, offsetBy: r.endIndex)
        return self[start..<end]
    }
}
