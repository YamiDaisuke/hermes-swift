//
//  KeyReader.swift
//
//  Based on source code: https://github.com/tuist/acho
//  Licensed under MIT License
//

import Foundation

/// Key events that the KeyReader delivers.
public enum KeyEvent {
    case up
    case down
    case left
    case right
    case backspace
    case delete // Forward backspace
    case enter
    case ascii(char: Character)
    case clear
    case unknow(code: UInt8)
}

public extension UInt8 {
    /// Returns the `Character` equivalente for this `UInt8`
    var character: Character {
        Character(UnicodeScalar(self))
    }
}

/// Protocol that defines the interface for subscribing
/// to key events
public protocol KeyReading {
    /// Subscribes to key events. It blocks the thread until an exit or enter event is delivered.
    ///
    /// - Parameter subscriber: Function to notify new key events through.
    func subscribe(subscriber: @escaping (KeyEvent) -> Void)
}

public class KeyReader: KeyReading {
    var fileHandle: FileHandle?
    var currentTerminal: termios?

    public init() { }

    /// Call this  function when you want to abort the current reading session
    /// and restore the terminal raw mode
    public func abort() {
        guard let handle = fileHandle else {
            return
        }

        guard let terminal = self.currentTerminal else {
            return
        }

        restoreRawMode(fileHandle: handle, originalTerm: terminal)
    }

    /// Subscribes to key events. It blocks the thread until an exit or enter event is delivered.
    ///
    /// - Parameter subscriber: Function to notify new key events through.
    public func subscribe(subscriber: @escaping (KeyEvent) -> Void) {
        let fileHandle = FileHandle.standardInput
        let originalTerm = enableRawMode(fileHandle: fileHandle)

        self.fileHandle = fileHandle
        self.currentTerminal = originalTerm

        var char: UInt8 = 0

        defer {
            restoreRawMode(fileHandle: fileHandle, originalTerm: originalTerm)
        }

        while read(fileHandle.fileDescriptor, &char, 1) == 1 {
            if char == 0x1B {
                guard read(fileHandle.fileDescriptor, &char, 1) == 1 else { break }
                if char == 0x5B {
                    guard read(fileHandle.fileDescriptor, &char, 1) == 1 else { break }
                    subscriber(mapArrowKeys(char))
                    break
                }
            } else if char == 0x0A {
                subscriber(.enter)
                break
            } else if char == 0x7F {
                subscriber(.backspace)
                break
            } else if char == 0x04 {
                subscriber(.delete)
                break
            } else if char == 0x0C {
                subscriber(.clear)
                break
            } else {
                subscriber(.ascii(char: char.character))
                break
            }
        }
    }

    private func mapArrowKeys(_ char: UInt8) -> KeyEvent {
        switch char {
        case 0x41:
            return .up
        case 0x42:
            return .down
        case 0x43:
            return .right
        case 0x44:
            return .left
        default:
            return .unknow(code: char)
        }
    }


    // MARK: - Fileprivate
    // https://stackoverflow.com/questions/49748507/listening-to-stdin-in-swift
    // https://stackoverflow.com/questions/24146488/swift-pass-uninitialized-c-structure-to-imported-c-function/24335355#24335355
    private func initStruct<S>() -> S {
        let structPointer = UnsafeMutablePointer<S>.allocate(capacity: 1)
        let structMemory = structPointer.pointee
        structPointer.deallocate()
        return structMemory
    }

    private func enableRawMode(fileHandle: FileHandle) -> termios {
        var raw: termios = initStruct()
        tcgetattr(fileHandle.fileDescriptor, &raw)

        let original = raw
        #if os(Linux)
        raw.c_lflag &= ~(UInt32(ECHO | ICANON))
        #else
        raw.c_lflag &= ~(UInt(ECHO | ICANON))
        #endif
        tcsetattr(fileHandle.fileDescriptor, TCSAFLUSH, &raw)

        return original
    }

    private func restoreRawMode(fileHandle: FileHandle, originalTerm: termios) {
        var term = originalTerm
        tcsetattr(fileHandle.fileDescriptor, TCSAFLUSH, &term)
    }
}
