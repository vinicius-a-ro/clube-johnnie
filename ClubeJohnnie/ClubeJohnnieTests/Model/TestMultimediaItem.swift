//
//  TestMultimediaItem.swift
//  ClubeJohnnie
//
//  Created by vinicius on 9/10/16.
//  Copyright © 2016 Bydoo. All rights reserved.
//

import Foundation
import RealmSwift
@testable import ClubeJohnnie

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Class -
//
//----------------------------------------------------------------------------------------------------------

class TestMultimediaItem : Object {
    
    dynamic var remoteURL: String = ""
    dynamic var cacheURL: String = ""
    dynamic var objectId: String = ""
}

extension TestMultimediaItem : RemoteAccessible {
    
    static var entityName: String {
        return "TestMultimediaItem"
    }
    
    static func map(json: JSON) -> TestMultimediaItem? {
        return TestMultimediaItem.map(json, urlKey: "url")
    }
    
    static func map(json: JSON, urlKey: String, associatedObject: Unique? = nil) -> TestMultimediaItem? {
        let id = "\(associatedObject?.objectId ?? "")-\(json[urlKey].stringValue)"
        let newItem = TestMultimediaItem.create(withId: id) as! TestMultimediaItem
        newItem.remoteURL = json[urlKey].stringValue
        return newItem
    }
}

extension TestMultimediaItem : LocalAccessible {
    
}