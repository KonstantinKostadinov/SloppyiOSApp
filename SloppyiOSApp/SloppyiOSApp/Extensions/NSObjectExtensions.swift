//
//  NSObjectExtensions.swift
//  SloppyiOSApp
//
//  Created by Konstantin Kostadinov on 3.09.21.
//

import Foundation

extension NSObject {
    func propertyNames() -> [String] {
        let mirror = Mirror(reflecting: self)
        return mirror.children.compactMap{ $0.label }
    }

    func propertyValues() -> [Any] {
        let mirror = Mirror(reflecting: self)
        return mirror.children.compactMap{ $0.value }
    }

    func propertyDictionary() -> [String:Any] {
        let mirror = Mirror(reflecting: self)
        var dictionary = [String: Any]()
            for (key, value) in mirror.children {
                if let key = key {
                    let snakeKey = key.replacingOccurrences(of: #"[A-Z]"#, with: "_$0", options: .regularExpression).lowercased()
                    dictionary[snakeKey] = value
                }
            }
        return dictionary
    }
}
