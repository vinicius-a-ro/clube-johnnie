//
//  TestMultimediaItem.swift
//  ClubeJohnnie
//
//  Created by vinicius on 9/10/16.
//  Copyright © 2016 Bydoo. All rights reserved.
//

import Foundation
@testable import ClubeJohnnie

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Class -
//
//----------------------------------------------------------------------------------------------------------

class TestMultimediaItem {
    
    dynamic var remoteURL: String = ""
    dynamic var cacheURL: String = ""
    
    static var entityName: String {
        return "TestMultimediaItem"
    }
}

extension TestMultimediaItem : RemoteAccessible {
    
    static func map(_ json: JSON) -> TestMultimediaItem? {
        return TestMultimediaItem.map(json, urlKey: "url")
    }
    
    static func map(_ json: JSON, urlKey: String, associatedObject: Unique? = nil) -> TestMultimediaItem? {
//        let id = "\(associatedObject?.objectId ?? "")-\(json[urlKey].stringValue)"
        let newItem = TestMultimediaItem()
        newItem.remoteURL = json[urlKey].stringValue
        return newItem
    }
}

//extension TestMultimediaItem : LocalAccessible {
//    typealias EntityType = TestMultimediaItem
//    var objectId: String {
//        get { return self.remoteURL }
//        set { self.remoteURL = newValue }
//    }
//}
