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

private func copy<T: Object>(object: T?) -> T? {
    guard let object = object else {
        return nil
    }
    let copy = T()
    for property in object.objectSchema.properties {
        copy[property.name] = object[property.name]
    }
    for ignoredProperty in object.dynamicType.ignoredProperties() {
        copy.setValue(object.valueForKey(ignoredProperty), forKey: ignoredProperty)
    }
    return copy
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
        
        if let realm = try? Realm() {
            _ = try? realm.write {
                realm.add(entity, update: true)
            }
        }
        return copy(entity)
    }
}

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Extension - Fetch -
//
//----------------------------------------------------------------------------------------------------------

extension LocalAccessible where EntityType : Object {
    
    static func fetchAll(sortKeys: [SortKey] = []) -> [EntityType] {
        var fetchedEntities: [EntityType] = []
        if let realm = try? Realm() {
            var results = realm.objects(EntityType.self)
            
            var sortProperties: [SortDescriptor] = []
            for key in sortKeys {
                switch key {
                case .Ascending(let value):
                    sortProperties.append(SortDescriptor(property: value, ascending: true))
                case .Descending(let value):
                    sortProperties.append(SortDescriptor(property: value, ascending: false))
                }
            }
            results = results.sorted(sortProperties)
            fetchedEntities = results.filter({ _ in return true })
        }
        return fetchedEntities.map({ copy($0)! })
    }
    
    static func fetch(withId id: String) -> EntityType? {
        var fetchedEntity: EntityType?
        if let realm = try? Realm() {
            fetchedEntity = realm.objects(EntityType.self).filter({ $0.objectId == id }).first
        }
        return copy(fetchedEntity)
    }
}

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Extension - Save -
//
//----------------------------------------------------------------------------------------------------------

extension LocalAccessible where EntityType : Object {
    
    static func save(objects: [EntityType], completion: ((savedObjects: [EntityType], error: NSError?) -> ())? = nil) {
        if let realm = try? Realm() {
            _ = try? realm.write {
                realm.add(objects, update: true)
            }
            let savedObjects = objects.map({ copy($0)! })
            completion?(savedObjects: savedObjects, error: nil)
        }
    }
}

