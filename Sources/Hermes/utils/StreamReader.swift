//
//  StreamReader.swift
//  Hermes
//
//  Created by Franklin Cruz on 25-01-21.
//

import Foundation

/// Reads a file line by line to keep it efficient
/// taken from: https://gist.github.com/sooop/a2b110f8eebdf904d0664ed171bcd7a2
public class StreamReader {
    let encoding: String.Encoding
    let chunkSize: Int
    let fileHandle: FileHandle
    var buffer: Data
    let delimPattern: Data
    var isAtEOF: Bool = false

    public init?(url: URL, delimeter: String = "\n", encoding: String.Encoding = .utf8, chunkSize: Int = 4096) {
        guard let fileHandle = try? FileHandle(forReadingFrom: url) else { return nil }
        self.fileHandle = fileHandle
        self.chunkSize = chunkSize
        self.encoding = encoding
        buffer = Data(capacity: chunkSize)
        delimPattern = delimeter.data(using: .utf8) ?? Data()
    }

    deinit {
        fileHandle.closeFile()
    }

    public func rewind() {
        fileHandle.seek(toFileOffset: 0)
        buffer.removeAll(keepingCapacity: true)
        isAtEOF = false
    }

    public func nextLine() -> String? {
        guard !isAtEOF else {
            return nil
        }
        repeat {
            if let range = buffer.range(of: delimPattern, options: [], in: buffer.startIndex..<buffer.endIndex) {
                let subData = buffer.subdata(in: buffer.startIndex..<range.upperBound)
                let line = String(data: subData, encoding: encoding)
                buffer.replaceSubrange(buffer.startIndex..<range.upperBound, with: [])
                return line
            } else {
                let tempData = fileHandle.readData(ofLength: chunkSize)
                if tempData.isEmpty {
                    isAtEOF = true
                    let line = (!buffer.isEmpty) ? String(data: buffer, encoding: encoding) : nil
                    return line
                }
                buffer.append(tempData)
            }
        } while true
    }
}
