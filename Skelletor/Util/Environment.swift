//
//  Environment.swift
//  Skelletor
//
//  Created by Ronaldo Faria Lima on 03/02/17.
//  Copyright © 2017 Nineteen Apps. All rights reserved.
//

import Foundation

/// This is a generic class which aims to organize a system's environment. An environment is a global state that is 
/// shared throughout the software.
public class Environment {
    var storage : [String:Any?] = [:]
    
    public init(){}
    
    /// Sets a given key's value into the environment store
    public func set(key: String, value: Any?) -> Self {
        storage[key] = value
        return self
    }
    
    /// Gets a given key's value from environment store
    public func get(key: String, value: inout Any?) -> Self {
        guard value != nil else {
            return self
        }
        value = nil
        if let gotValue = storage[key] {
            value = gotValue
        }
        return self
    }
    
    /// Subscript for subscripting data
    public subscript(index: String) -> Any? {
        get {
            let value = storage[index]
            guard value != nil else {
                return nil
            }
            return value as Any
        }
        set(newValue) {
            storage[index] = newValue
        }
    }
}
