//
//  RealmAccessible.swift
//  ClubeJohnnie
//
//  Created by vinicius on 9/5/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation
import RealmSwift

extension Object {
    static func primaryKey() -> String? {
        if self is Unique.Type {
            return "objectId"
        }
        return nil
    }
}

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Extension - Create -
//
//----------------------------------------------------------------------------------------------------------

extension LocalAccessible where EntityType : Object {
    
    static func create(withId id: String) -> EntityType? {
        var entity = EntityType()
        entity.objectId = id
        return entity
    }
}

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Extension - Fetch -
//
//----------------------------------------------------------------------------------------------------------

extension LocalAccessible where EntityType : Object {
    
    static func fetchAll(sortKeys: [SortKey]? = []) -> [EntityType] {
        var fetchedEntities: [EntityType] = []
        if let realm = try? Realm() {
            var results = realm.objects(EntityType.self)
            
            if let sortKeys = sortKeys {
                for key in sortKeys {
                    switch key {
                    case .Ascending(let value):
                        results = results.sorted(value, ascending: true)
                    case .Descending(let value):
                        results = results.sorted(value, ascending: false)
                    }
                }
            }
            
            fetchedEntities = results.filter({ _ in return true })
        }
        return fetchedEntities
    }
    
    static func fetch(withId id: String) -> EntityType? {
        var fetchedEntity: EntityType?
        if let realm = try? Realm() {
            fetchedEntity = realm.objects(EntityType.self).filter({ $0.objectId == id }).first
        }
        return fetchedEntity
    }
}

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Extension - Save -
//
//----------------------------------------------------------------------------------------------------------

extension LocalAccessible where EntityType : Object {
    
    static func save(objects: [EntityType], completion: ((error: NSError?) -> ())? = nil) {
        if let realm = try? Realm() {
            _ = try? realm.write {
                realm.add(objects, update: true)
                completion?(error: nil)
            }
        }
    }
}
