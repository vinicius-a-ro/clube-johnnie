//
//  TestUser.swift
//  AgileDashboard
//
//  Created by vinicius on 6/14/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation
@testable import ClubeJohnnie

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Class -
//
//----------------------------------------------------------------------------------------------------------

class TestUser {
    
    var testUserId: String = ""
    var name: String = ""
    var age: Int = 0
    var verified: Bool = false
    var profilePicture: TestMultimediaItem?
}

extension TestUser : RemoteAccessible {
    
    static var entityName: String {
        return "TestUser"
    }
    
    static func map(_ json: JSON) -> TestUser? {
        let testUser = TestUser()
        testUser.testUserId = json["testUserId"].stringValue
        testUser.name = json["name"].stringValue
        testUser.age = json["age"].intValue
        testUser.verified = json["verified"].boolValue
//        testUser.profilePicture = TestMultimediaItem.map(json, urlKey: "profilePictureURL", associatedObject: testUser)!
        return testUser
    }
}

//extension TestUser : LocalAccessible {
//    typealias EntityType = TestUser
//    var objectId: String {
//        get { return self.testUserId }
//        set { self.testUserId = newValue }
//    }
//}
