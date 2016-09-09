//
//  RemoteTests.swift
//  AgileDashboard
//
//  Created by vinicius on 6/18/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import XCTest
@testable import ClubeJohnnie

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Class -
//
//----------------------------------------------------------------------------------------------------------

class RemoteTests: ClubeJohnnieTests {
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

//--------------------------------------------------
// MARK: - Get
//--------------------------------------------------
    
    func testRemoteGET_ByGettingUserFromServer_ShouldReturnValidJSON() {
        let expectation = self.expectationWithDescription("get request")
        
        TestUser.get(withId: "1") { (json, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(json)
            XCTAssertEqual(json!["name"].stringValue, "John")
            XCTAssertEqual(json!["age"].intValue, 26)
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(10, handler: nil)
    }

    func testRemoteGET_ByGettingAllUserFromServer_ShouldReturnValidJSON() {
        let expectation = self.expectationWithDescription("get all request")
        
        TestUser.getAll { (json, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(json)
            XCTAssertNotNil(json?.array)
            
            XCTAssertEqual(json?.array![0]["testUserId"].stringValue, "1")
            XCTAssertEqual(json?.array![0]["name"].stringValue, "John")
            XCTAssertEqual(json?.array![0]["age"].intValue, 26)
            
            XCTAssertEqual(json?.array![1]["testUserId"].stringValue, "2")
            XCTAssertEqual(json?.array![1]["name"].stringValue, "Mary")
            XCTAssertEqual(json?.array![1]["age"].intValue, 28)
            
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(10, handler: nil)
    }
    
//--------------------------------------------------
// MARK: - Map
//--------------------------------------------------
    
    func testRemoteMap_ByMappingRemoteJSONToUser_ShouldMapJSONValuesIntoModelObject() {
        let expectation = self.expectationWithDescription("get request + map")
        
        TestUser.get(withId: "1") { (json, error) in
            let testUser = TestUser.map(json!)!
            XCTAssertNil(error)
            XCTAssertEqual(testUser.name, "John")
            XCTAssertEqual(testUser.age, 26)
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testRemoteMap_ByMappingRemoteJSONArrayToUser_ShouldMapJSONValuesIntoModelObject() {
        let expectation = self.expectationWithDescription("get all request + map")
        
        TestUser.getAll { (json, error) in
            
            let testUsers = TestUser.mapArray(json!)
            XCTAssertNotNil(testUsers)
            
            XCTAssertEqual(testUsers[0].testUserId, "1")
            XCTAssertEqual(testUsers[0].name, "John")
            XCTAssertEqual(testUsers[0].age, 26)
            
            XCTAssertEqual(testUsers[1].testUserId, "2")
            XCTAssertEqual(testUsers[1].name, "Mary")
            XCTAssertEqual(testUsers[1].age, 28)
            
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(10, handler: nil)
    }
    
//--------------------------------------------------
// MARK: - Remote Storage
//--------------------------------------------------
    
}