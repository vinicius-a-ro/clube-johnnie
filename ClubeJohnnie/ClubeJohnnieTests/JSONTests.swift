//
//  JSONTests.swift
//  ClubeJohnnie
//
//  Created by vinicius on 9/8/16.
//  Copyright © 2016 Bydoo. All rights reserved.
//

import Foundation
import XCTest
@testable import ClubeJohnnie

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Class -
//
//----------------------------------------------------------------------------------------------------------

class JSONTests : XCTestCase {
    
//--------------------------------------------------
// MARK: - Properties
//--------------------------------------------------
    
    var jsonData: NSData {
        let bundle = NSBundle(forClass: JSONTests.self)
        let filePath = bundle.pathForResource("User", ofType: "json")
        return NSData(contentsOfFile: filePath!)!
    }
    
    var json: JSON {
        return JSON(data: self.jsonData)
    }
    
//--------------------------------------------------
// MARK: - Configuration
//--------------------------------------------------
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
//--------------------------------------------------
// MARK: - Tests
//--------------------------------------------------
    
    func testJSON_WithJSONContainingDictionary_ShouldSubscriptDictionaryCorrectly() {
        XCTAssertNotNil(self.json["user"])
    }
    
    func testJSON_WithJSONContainingArray_ShouldParseArrayCorrectly() {
        XCTAssertNotNil(self.json["user"]["rewardsHistory"].array)
        XCTAssertTrue(self.json["user"]["rewardsHistory"].arrayValue.count > 0)
    }
    
    func testJSON_WithJSONContainingArray_ShouldSubscriptArrayCorrectly() {
        let rewardsHistory = self.json["user"]["rewardsHistory"]
        let firstReward = rewardsHistory[0]
        XCTAssertTrue(rewardsHistory.type == .Array, "getting \(rewardsHistory.type) instead of Array expected")
        XCTAssertEqual(firstReward["name"].stringValue, "Milkshake")
    }
    
    func testJSON_WithJSONContainingString_ShouldParseStringCorrectly() {
        XCTAssertNotNil(self.json["user"]["name"].string)
        XCTAssertEqual(self.json["user"]["name"].stringValue, "Vinicius Rodrigues")
    }
    
    func testJSON_WithJSONContainingInt_ShouldParseIntCorrectly() {
        XCTAssertNotNil(self.json["user"]["age"].int)
        XCTAssertEqual(self.json["user"]["age"].intValue, 27)
    }
    
    func testJSON_WithJSONContainingFloat_ShouldParseIntCorrectly() {
        XCTAssertNotNil(self.json["user"]["height"].float)
        XCTAssertEqual(self.json["user"]["height"].float, 1.69)
    }
}
