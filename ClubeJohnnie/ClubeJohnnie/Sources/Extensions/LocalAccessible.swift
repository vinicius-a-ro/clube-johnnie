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
    case ascending(String)
    case descending(String)
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
    associatedtype EntityType : Unique
    static func create(withId id: String) -> EntityType?
    static func fetchAll(_ sortKeys: [SortKey]) -> [EntityType]
    static func fetch(withId id: String) -> EntityType?
    static func save(_ objects: [EntityType], completion: ((_ savedObjects: [EntityType], _ error: NSError?) -> ())?)
}
