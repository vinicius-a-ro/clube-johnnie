//
//  String.swift
//  ClubeJohnnie
//
//  Created by vinicius on 9/5/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import Foundation

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Case -
//
//----------------------------------------------------------------------------------------------------------

extension String {
    var first: String {
        return String(characters.prefix(1))
    }
    var lowercaseFirst: String {
        return first.lowercased() + String(characters.dropFirst())
    }
}
