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
    case Dictionary
    case Array
    case String
    case Number
    case Null
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
    
    private var _type: JSONType = .Null
    private var _object: AnyObject?
    private var object: AnyObject? {
        get {
            return self._object
        }
        set {
            self._object = newValue
            switch newValue {
            case _ as [AnyObject]: self._type = .Array
            case _ as [String : AnyObject]: self._type = .Dictionary
            case _ as NSNumber: self._type = .Number
            case _ as String: self._type = .String
            default:
                self._type = .Null
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
    
    public init(object: AnyObject? = nil) {
        self.object = object
    }
    
    public init(data: NSData?) {
        if let data = data {
            do {
                let object: AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
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
            if self.type == .Dictionary {
                let dict = self.object as! [String : AnyObject]
                return JSON(object: dict[key])
            }
            return JSON()
        }
        set {
            if self.type == .Dictionary {
                var dict = self.object as! [String : AnyObject]
                dict[key] = newValue.object
                self.object = dict
            }
        }
    }
    
    public subscript(index: Int) -> JSON {
        get {
            if self.type == .Array {
                let array = self.object as! [AnyObject]
                return JSON(object: array[index])
            }
            return JSON()
        }
        set {
            if self.type == .Array {
                var array = self.object as! [AnyObject]
                array[index] = newValue.object!
                self.object = array
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
        return self.type == .Number ? self.object as? NSNumber : nil
    }
    
    public var int: Int? {
        return self.type == .Number ? self.numberValue?.integerValue : nil
    }
    
    public var intValue: Int {
        return self.int ?? 0
    }
    
    public var float: Float? {
        return self.type == .Number ? self.numberValue?.floatValue : nil
    }
    
    public var floatValue: Float {
        return self.float ?? 0.0
    }
    
    public var string: String? {
        return self.type == .String ? self.object as? String : nil
    }
   
    public var stringValue: String {
        return self.string ?? ""
    }
    
    public var array: [AnyObject]? {
        return self.type == .Array ? self.object as? [AnyObject] : nil
    }
    
    public var arrayValue: [AnyObject] {
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
        case .Array, .Dictionary:
            let data = try! NSJSONSerialization.dataWithJSONObject(self.object!, options: .PrettyPrinted)
            return NSString(data: data, encoding: NSUTF8StringEncoding) as? String ?? "unknown"
        default:
            return "\(self.object)"
        }
    }
    
    public var debugDescription: String {
        return self.description
    }
}