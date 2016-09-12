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

protocol LocalAccessible : Unique {
    associatedtype DataAccessor : DataAccessorType
    static var dataAccess: DataAccessor {get}
}

protocol DataAccessorType {
    associatedtype EntityType
    func create(withId id: String) -> EntityType?
    func fetchAll(sortKeys: [SortKey]) -> [EntityType]
    func fetch(withId id: String) -> EntityType?
    func save(objects: [EntityType], completion: ((savedObjects: [EntityType], error: NSError?) -> ())?)
}
