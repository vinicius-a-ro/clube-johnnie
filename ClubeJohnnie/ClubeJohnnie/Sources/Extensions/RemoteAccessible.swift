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

typealias RemoteResult = (_ json: JSON?, _ error: Error?) -> ()

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Definitions -
//
//----------------------------------------------------------------------------------------------------------

protocol RemoteAccessible {
    associatedtype EntityType
    static var entityName: String {get}
    static func map(_ json: JSON) -> EntityType?
    static func mapArray(_ json: JSON) -> [EntityType]
}

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Get -
//
//----------------------------------------------------------------------------------------------------------

extension RemoteAccessible {
    
    static func getAll(_ sortKeys: [SortKey]? = [], completion: @escaping RemoteResult) {
        NetworkManager.sharedInstance.request(.get, url: "/\(self.entityName.lowercaseFirst)", completion: completion)
    }
    
    static func get(withId id: String, completion: @escaping RemoteResult) {
        NetworkManager.sharedInstance.request(.get, url: "/\(self.entityName.lowercaseFirst)/\(id)", completion: completion)
    }
}

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Mapping -
//
//----------------------------------------------------------------------------------------------------------

extension RemoteAccessible {
    
    static func mapArray(_ json: JSON) -> [EntityType] {
        
        var mappedObjects = [EntityType]()
        
        for objectJson in json.arrayValue {
            
            if objectJson.type == .array {
                mappedObjects.append(contentsOf: self.mapArray(objectJson))
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
