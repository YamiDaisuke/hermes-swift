//
//  Object.swift
//  rosetta
//
//  Created by Franklin Cruz on 07-01-21.
//

import Foundation

typealias ObjectType = String

protocol Object: CustomStringConvertible {
    var type: ObjectType { get }
}

struct Null: Object {
    var type: ObjectType

    var description: String { "null" }
}

struct Integer: Object {
    var type: ObjectType { "Integer" }
    var value: Int

    var description: String {
        value.description
    }
}

struct Boolean: Object {
    static let `true` = Boolean(value: true)
    static let `false` = Boolean(value: false)

    var type: ObjectType { "Boolean" }
    var value: Bool

    var description: String {
        value.description
    }
}
