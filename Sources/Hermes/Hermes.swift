//
//  File.swift
//  Hermes
//
//  Created by Franklin Cruz on 27-04-21.
//

import Foundation

/// Holds basic informacion about this package
public struct Hermes { }

extension Hermes {
    /// The current version of the byte code supported by this library
    public static var byteCodeVersion: String {
        /// TODO: Generate this dynamically during compilation
        "2.0.0"
    }

    /// A magic number to mark a binary file valid for the Hermes VM
    /// This will not change
    public static var fileSignature: UInt32 {
        1619564582
    }
}
