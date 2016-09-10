//
//  LocalAccessible.swift
//  ClubeJohnnie
//
//  Created by vinicius on 6/14/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Definitions -
//
//----------------------------------------------------------------------------------------------------------

public enum SortKey {
    case Ascending(String)
    case Descending(String)
}

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Definitions -
//
//----------------------------------------------------------------------------------------------------------

protocol Unique {
    var objectId: String {get set}
}

protocol LocalAccessible {
    
    associatedtype EntityType : Unique
    
    static var entityName: String {get}
    
    static func create(withId id: String) -> EntityType?
    static func fetchAll(sortKeys: [SortKey]) -> [EntityType]
    static func fetch(withId id: String) -> EntityType?
    static func save(objects: [EntityType], completion: ((error: NSError?) -> ())?)
}

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Extension - Default Values -
//
//----------------------------------------------------------------------------------------------------------

extension LocalAccessible {
    static func fetchAll(sortKeys: [SortKey] = [], completion: (data: [EntityType], error: NSError?) -> ()) {
        let data = self.fetchAll(sortKeys)
        completion(data: data, error: nil)
    }
}