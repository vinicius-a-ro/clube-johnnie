//
//  RemoteAccessible.swift
//  ClubeJohnnie
//
//  Created by vinicius on 6/15/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Constants -
//
//----------------------------------------------------------------------------------------------------------

typealias RemoteResult = (json: JSON?, error: NSError?) -> ()

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Definitions -
//
//----------------------------------------------------------------------------------------------------------

protocol RemoteAccessible {
    associatedtype EntityType
    static var entityName: String {get}
    static func map(json: JSON) -> EntityType?
    static func mapArray(json: JSON) -> [EntityType]
}

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Get -
//
//----------------------------------------------------------------------------------------------------------

extension RemoteAccessible {
    
    static func getAll(sortKeys: [SortKey]? = [], completion: RemoteResult) {
        NetworkManager.sharedInstance.request(.GET, url: "/\(self.entityName.lowercaseFirst)", completion: completion)
    }
    
    static func get(withId id: String, completion: RemoteResult) {
        NetworkManager.sharedInstance.request(.GET, url: "/\(self.entityName.lowercaseFirst)/\(id)", completion: completion)
    }
}

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Mapping -
//
//----------------------------------------------------------------------------------------------------------

extension RemoteAccessible {
    
    static func mapArray(json: JSON) -> [EntityType] {
        
        var mappedObjects = [EntityType]()
        
        for objectJson in json.arrayValue {
            
            if objectJson.type == .Array {
                mappedObjects.appendContentsOf(self.mapArray(objectJson))
            }
            else {
                if let object = self.map(objectJson) {
                    mappedObjects.append(object)
                }
            }
        }
        return mappedObjects
    }
}