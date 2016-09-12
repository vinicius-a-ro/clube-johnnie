//
//  RealmAccessible.swift
//  ClubeJohnnie
//
//  Created by vinicius on 9/5/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation
import RealmSwift

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Definitions -
//
//----------------------------------------------------------------------------------------------------------

extension Object {
    static func primaryKey() -> String? {
        if self is Unique.Type {
            return "objectId"
        }
        return nil
    }
}

extension LocalAccessible where Self : Object, Self : Unique {
    static var dataAccess: RealmAccessor<Self> {
        return RealmAccessor()
    }
}

private func realmCopy<T:Object>(object: T?) -> T? {
    guard let object = object else {
        return nil
    }
    let copy = object.dynamicType.init()
    for property in object.objectSchema.properties {
        let value = object[property.name]
        if let obj = value as? Object {
            copy[property.name] = realmCopy(obj)
        }
        else {
            copy[property.name] = value
        }
    }
    for ignoredProperty in object.dynamicType.ignoredProperties() {
        copy.setValue(object.valueForKey(ignoredProperty), forKey: ignoredProperty)
    }
    return copy
}

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Struct -
//
//----------------------------------------------------------------------------------------------------------

struct RealmAccessor<Type:Object> : DataAccessorType {
    typealias EntityType = Type
    
//--------------------------------------------------
// MARK: - Create
//--------------------------------------------------
    
    func create(withId id: String) -> Type? {
        let object = Type()
        if var uniqueObject = object as? Unique {
            uniqueObject.objectId = id
        }
        return object
    }
    
//--------------------------------------------------
// MARK: - Fetch
//--------------------------------------------------
    
    func fetch(withId id: String) -> Type? {
        var fetchedEntity: Type?
        if let realm = try? Realm() {
            fetchedEntity = realm.objects(Type.self).filter({ (element: Type) -> Bool in
                return (element as? Unique)?.objectId == id
            }).first
        }
        return realmCopy(fetchedEntity)
    }
    
    func fetchAll(sortKeys: [SortKey] = []) -> [Type] {
        var fetchedEntities: [Type] = []
        if let realm = try? Realm() {
            var results = realm.objects(Type.self)
            
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
        return fetchedEntities.map({ $0 })
    }
    
//--------------------------------------------------
// MARK: - Save
//--------------------------------------------------
    
    func save(objects: [Type], completion: ((savedObjects: [Type], error: NSError?) -> ())?) {
        if let realm = try? Realm() {
            _ = try? realm.write {
                realm.add(objects, update: true)
            }
            let savedObjects = objects.map({ realmCopy($0)! })
            completion?(savedObjects: savedObjects, error: nil)
        }
    }
}