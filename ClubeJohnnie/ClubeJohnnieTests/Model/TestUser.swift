//
//  TestUser.swift
//  AgileDashboard
//
//  Created by vinicius on 6/14/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation
import RealmSwift
@testable import ClubeJohnnie

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Class -
//
//----------------------------------------------------------------------------------------------------------

class TestUser : Object {
    
    dynamic var testUserId: String = ""
    dynamic var name: String = ""
    dynamic var age: Int = 0
    dynamic var verified: Bool = false
    
    var someNotStoredProperty: String = "Value"
    
    override static func ignoredProperties() -> [String] {
        return ["someNotStoredProperty"]
    }
}

extension TestUser : RemoteAccessible {
    
    static var entityName: String {
        return "TestUser"
    }
    
    static func map(json: JSON) -> TestUser? {
        let testUser = TestUser()
        testUser.testUserId = json["testUserId"].stringValue
        testUser.name = json["name"].stringValue
        testUser.age = json["age"].intValue
        testUser.verified = json["verified"].boolValue
        return testUser
    }
}

extension TestUser : LocalAccessible, Unique {
    typealias EntityType = TestUser
    
    var objectId: String {
        get { return self.testUserId }
        set { self.testUserId = newValue }
    }
}