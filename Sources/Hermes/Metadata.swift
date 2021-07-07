//
//  File.swift
//  Hermes
//
//  Created by Franklin Cruz on 27-04-21.
//

import Foundation

/// Tells at which level two semantic version numbers should match to
/// be considered compatible
public enum SemVersionCompatibility {
    /// Requires all three values to match
    case exact
    /// Requires only major version to match. Minor and patch should be greater than or equal
    case minor
    /// Requires major and minor version to match. Patch should be greater than or equal
    case patch
}

/// A struct to esly hold semantic version values. E.G.: 1.1.1
public struct SemVersion: CustomStringConvertible {
    public var major: UInt16
    public var minor: UInt16
    public var patch: UInt16

    public init(major: UInt16, minor: UInt16, patch: UInt16) {
        self.major = major
        self.minor = minor
        self.patch = patch
    }

    /// Reads the value from a byte array of at lest 6 bytes
    public init(_ bytes: [Byte]) {
        self.major = UInt16(bytes.readInt(bytes: .word) ?? -1)
        self.minor = UInt16(bytes.readInt(bytes: .word, startIndex: 2) ?? -1)
        self.patch = UInt16(bytes.readInt(bytes: .word, startIndex: 4) ?? -1)
    }

    /// Returns the  byte representation of this version
    public var bytes: [Byte] {
        return self.major.bytes + self.minor.bytes + self.patch.bytes
    }


    /// Determinates if another version is compatible with this one
    /// - Parameters:
    ///   - other: The other version to compare
    ///   - component: At which level this two version must be compatible
    /// - Returns: `true` if `other` is compatible with `self`
    public func isCompatible(_ other: SemVersion, component: SemVersionCompatibility) -> Bool {
        switch component {
        case .exact:
            return other.major == self.major && other.minor == self.minor && other.patch == self.patch
        case .patch:
            return other.major == self.major && other.minor == self.minor && other.patch >= self.patch
        case .minor:
            return other.major == self.major && other.minor >= self.minor && other.patch >= self.patch
        }
    }

    public var description: String {
        "\(self.major).\(self.minor).\(self.patch)"
    }
}

/// Holds basic informacion about this package
public struct HermesMetadata { }

extension HermesMetadata {
    /// The current version of the byte code supported by this library
    public static var byteCodeVersion: SemVersion {
        /// TODO: Generate this dynamically during compilation
        SemVersion(major: 2, minor: 0, patch: 1)
    }

    /// A magic number to mark a binary file valid for the Hermes VM
    /// This will not change
    public static var fileSignature: UInt32 {
        1619564582
    }
}
