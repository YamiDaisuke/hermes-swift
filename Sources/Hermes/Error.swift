//
//  Error.swift
//  Rosetta
//
//  Created by Franklin Cruz on 27-01-21.
//

import Foundation

/// Base error protocol for this library, it includes optional information
/// to print the script line, column and file where the error occurs if
/// supported by the language
public protocol RosettaError: Error, CustomStringConvertible {
    var message: String { get }
    var line: Int? { get set }
    var column: Int? { get set }
    var file: String? { get set }
}

/// Convinience extension to print all available information contained in the error
public extension RosettaError {
    var description: String {
        var output = self.message

        if let line = line, let col = column {
            output += " at Line: \(line), Column: \(col)"
        }

        if let file = self.file {
            output += "\nAt file: \(file)"
        }

        return output
    }
}
