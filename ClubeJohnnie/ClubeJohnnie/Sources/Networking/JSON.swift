//
//  JSON.swift
//  ClubeJohnnie
//
//  Created by vinicius on 9/6/16.
//  Copyright © 2016 Bydoo. All rights reserved.
//

import Foundation

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Definitions -
//
//----------------------------------------------------------------------------------------------------------

public enum JSONType {
    case dictionary
    case array
    case string
    case number
    case null
}

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Struct -
//
//----------------------------------------------------------------------------------------------------------

public struct JSON {
    
//--------------------------------------------------
// MARK: - Properties
//--------------------------------------------------
    
    fileprivate var _type: JSONType = .null
    fileprivate var _object: Any?
    fileprivate var object: Any? {
        get {
            return self._object
        }
        set {
            self._object = newValue
            switch newValue {
            case _ as [Any]: self._type = .array
            case _ as [String : Any]: self._type = .dictionary
            case _ as NSNumber: self._type = .number
            case _ as String: self._type = .string
            default:
                self._type = .null
                self._object = nil
            }
        }
    }
    
    public var type: JSONType {
        return _type
    }
    
//--------------------------------------------------
// MARK: - Initializers
//--------------------------------------------------
    
    public init(object: Any? = nil) {
        self.object = object
    }
    
    public init(data: Data?) {
        if let data = data {
            do {
                let object: Any = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                self.init(object: object)
            } catch {
                self.init()
            }
        }
        else {
            self.init()
        }
    }
}

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Extension - Subscript
//
//----------------------------------------------------------------------------------------------------------

extension JSON {
    
    public subscript(key: String) -> JSON {
        get {
            if self.type == .dictionary {
                let dict = self.object as! [String : Any]
                return JSON(object: dict[key])
            }
            return JSON()
        }
        set {
            if self.type == .dictionary {
                var dict = self.object as! [String : Any]
                dict[key] = newValue.object
                self.object = dict as Any?
            }
        }
    }
    
    public subscript(index: Int) -> JSON {
        get {
            if self.type == .array {
                let array = self.object as! [Any]
                return JSON(object: array[index])
            }
            return JSON()
        }
        set {
            if self.type == .array {
                var array = self.object as! [Any]
                array[index] = newValue.object!
                self.object = array as Any?
            }
        }
    }
}

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Extension - Raw Values
//
//----------------------------------------------------------------------------------------------------------

extension JSON {
 
    public var numberValue: NSNumber? {
        return self.type == .number ? self.object as? NSNumber : nil
    }
    
    public var int: Int? {
        return self.type == .number ? self.numberValue?.intValue : nil
    }
    
    public var intValue: Int {
        return self.int ?? 0
    }
    
    public var bool: Bool? {
        switch self.type {
        case .number: return self.numberValue?.boolValue
        case .string:
            let stringValue = self.stringValue.lowercased()
            return stringValue == "true" || stringValue == "t"
        default: return nil
        }
    }
    
    public var boolValue: Bool {
        return self.bool ?? false
    }
    
    public var float: Float? {
        return self.type == .number ? self.numberValue?.floatValue : nil
    }
    
    public var floatValue: Float {
        return self.float ?? 0.0
    }
    
    public var string: String? {
        return self.type == .string ? self.object as? String : nil
    }
   
    public var stringValue: String {
        return self.string ?? ""
    }
    
    public var array: [JSON]? {
        if self.type == .array {
            return (self.object as! [Any]).map({ JSON(object: $0) })
        }
        return nil
    }
    
    public var arrayValue: [JSON] {
        return self.array ?? []
    }
}

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Extension - Debuging
//
//----------------------------------------------------------------------------------------------------------

extension JSON : CustomStringConvertible, CustomDebugStringConvertible {
    
    public var description: String {
        switch self.type {
        case .array, .dictionary:
            let data = try! JSONSerialization.data(withJSONObject: self.object!, options: .prettyPrinted)
            return NSString(data: data, encoding: String.Encoding.utf8.rawValue) as? String ?? "unknown"
        default:
            return "\(self.object)"
        }
    }
    
    public var debugDescription: String {
        return self.description
    }
}
