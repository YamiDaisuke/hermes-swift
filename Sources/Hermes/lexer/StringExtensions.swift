//
//  StringExtensions.swift
//  Hermes
//
//  Created by Franklin Cruz on 28-12-20.
//

import Foundation

extension String {
    /// Returns `true` if this `String` contains only characters consider
    /// a valid letter for identifiers
    public var isLetter: Bool {
        self =~ "[a-zA-Z_]"
    }

    /// Prints all lines in the string with a consistent level of indentation
    /// - Parameters:
    ///   - level: How many indentation levels to print. Default: 1
    ///   - spacer: Which string to use as spacer. Default: "\t"
    /// - Returns: The indented string
    public func indented(level: Int = 1, spacer: String = "\t") -> String {
        let tab = String(repeating: spacer, count: level)
        return self.split(separator: "\n")
            .map { "\(tab)\($0)" }
            .joined(separator: "\n")
    }
}

let latinDigits: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
// swiftlint:disable line_length
let latinLetters: Set<Character> = [
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
]
// swiftlint:enable line_length

extension Character {
    /// Returns `true` if this `Character` is  considered
    /// a valid letter for identifiers first `Character`
    public var isValidIdentifierStart: Bool {
        return latinLetters.contains(self) || self == "_"
    }

    /// Returns `true` if this `Character` is  considered
    /// a valid letter for identifiers
    public var isIdentifierCharacter: Bool {
        return latinLetters.contains(self) || latinDigits.contains(self) || self == "_"
    }

    /// Returns `true` if this `Character` is considered a digit
    /// with support for only latin digits 0-9
    public var isDigit: Bool {
        return latinDigits.contains(self)
    }
}

infix operator =~
public extension String {
    /// Compares a `String` against another string containing a regular expression
    ///
    /// - Parameters:
    ///   - lhs: The `String` to match
    ///   - rhs: A `String` containing a valid regular expression to match againts `lhs`
    /// - Returns: `true` if `lhs` matches the regular expression in `rhs` or `false` otherwise
    static func =~ (lhs: String, rhs: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: rhs) else { return false }
        let range = NSRange(location: 0, length: lhs.utf16.count)
        return regex.firstMatch(in: lhs, options: [], range: range) != nil
    }
}

public extension String {
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
        let range = range.relative(to: [Bool](repeating: false, count: self.count))
        let start = self.index(self.startIndex, offsetBy: range.startIndex)
        let end = self.index(self.startIndex, offsetBy: range.endIndex)
        return self[start..<end]
    }
}
