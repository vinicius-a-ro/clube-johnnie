//
//  RemoteLocalAccessible.swift
//  ClubeJohnnie
//
//  Created by vinicius on 6/15/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Definitions -
//
//----------------------------------------------------------------------------------------------------------

protocol RemoteLocalAccessible: RemoteAccessible, LocalAccessible {}

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Load -
//
//----------------------------------------------------------------------------------------------------------

//extension RemoteLocalAccessible {
//    
//    typealias EntityArrayResult = (data: [EntityType], error: NSError?) -> ()
//    
//    static func loadAll(sortKeys: [SortKey] = [], returnCachedResults: Bool = true, completion: EntityArrayResult) {
//        
//        if returnCachedResults {
//            completion(data: self.dataAccess.fetchAll(sortKeys), error: nil)
//        }
//        
//        self.getAll { (json, error) in
//            if let json = json {
//                let objects = self.mapArray(json)
//                self.dataAccess.save(objects) { (savedObjects, error) in
//                    completion(data: savedObjects, error: error)
//                }
//            }
//            else {
//                completion(data: [], error: error)
//            }
//        }
//    }
//}