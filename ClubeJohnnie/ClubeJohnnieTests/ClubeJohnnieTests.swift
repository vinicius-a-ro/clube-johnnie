//
//  ClubeJohnnieTests.swift
//  ClubeJohnnie
//
//  Created by vinicius on 9/8/16.
//  Copyright © 2016 Bydoo. All rights reserved.
//

import XCTest
@testable import ClubeJohnnie

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Class -
//
//----------------------------------------------------------------------------------------------------------

class ClubeJohnnieTests : XCTestCase {
    
    override func setUp() {
        super.setUp()
        NetworkManager.sharedInstance.baseURLString = "http://private-04b2-agiledashboard2.apiary-mock.com"
    }
    
    override func tearDown() {
        super.tearDown()
    }
}
