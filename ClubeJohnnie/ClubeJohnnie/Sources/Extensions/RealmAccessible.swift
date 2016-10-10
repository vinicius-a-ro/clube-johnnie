////
////  RealmAccessible.swift
////  ClubeJohnnie
////
////  Created by vinicius on 9/5/16.
////  Copyright © 2016 IBM. All rights reserved.
////
//
//import Foundation
//import RealmSwift
//
////----------------------------------------------------------------------------------------------------------
////
//// MARK: - Definitions -
////
////----------------------------------------------------------------------------------------------------------
//
//extension Object {
//    static func primaryKey() -> String? {
//        if self is Unique.Type {
//            return "objectId"
//        }
//        return nil
//    }
//}
//
//private func realmCopy<T:Object>(_ object: T) -> T {
//    let copy = type(of: object).init()
//    for property in object.objectSchema.properties {
//        let value = object[property.name]
//        if let obj = value as? Object {
//            copy[property.name] = realmCopy(obj)
//        }
//        else {
//            copy[property.name] = value
//        }
//    }
//    for ignoredProperty in type(of: object).ignoredProperties() {
//        copy.setValue(object.value(forKey: ignoredProperty), forKey: ignoredProperty)
//    }
//    return copy
//}
//
////----------------------------------------------------------------------------------------------------------
////
//// MARK: - Extension - Create
////
////----------------------------------------------------------------------------------------------------------
//
//extension LocalAccessible where EntityType : Object {
//    
//    static func create(withId id: String) -> EntityType? {
//        var object = EntityType()
//        object.objectId = id
//        return object
//    }
//}
//
////----------------------------------------------------------------------------------------------------------
////
//// MARK: - Extension - Fetch
////
////----------------------------------------------------------------------------------------------------------
//
//extension LocalAccessible where EntityType : Object {
//    
//    static func fetch(withId id: String) -> EntityType? {
//        var fetchedEntity: EntityType?
//        if let realm = try? Realm() {
//            fetchedEntity = realm.objects(EntityType.self).filter({ $0.objectId == id }).first
//        }
//        return fetchedEntity != nil ? realmCopy(fetchedEntity!) : nil
//    }
//    
//    static func fetchAll(_ sortKeys: [SortKey] = []) -> [EntityType] {
//        var fetchedEntities: [EntityType] = []
//        if let realm = try? Realm() {
//            var results = realm.objects(EntityType.self)
//            
//            var sortProperties: [SortDescriptor] = []
//            for key in sortKeys {
//                switch key {
//                case .ascending(let value):
//                    sortProperties.append(SortDescriptor(property: value, ascending: true))
//                case .descending(let value):
//                    sortProperties.append(SortDescriptor(property: value, ascending: false))
//                }
//            }
//            results = results.sorted(sortProperties)
//            fetchedEntities = results.filter({ _ in return true })
//        }
//        return fetchedEntities.map({ realmCopy($0) })
//    }
//}
//
////----------------------------------------------------------------------------------------------------------
////
//// MARK: - Extension - Save
////
////----------------------------------------------------------------------------------------------------------
//
//extension LocalAccessible where EntityType : Object {
//    
//    static func save(_ objects: [EntityType], completion: ((_ savedObjects: [EntityType], _ error: NSError?) -> ())?) {
//        if let realm = try? Realm() {
//            _ = try? realm.write {
//                realm.add(objects, update: true)
//            }
//            let savedObjects = objects.map({ realmCopy($0) })
//            completion?(savedObjects: savedObjects, error: nil)
//        }
//    }
//}
