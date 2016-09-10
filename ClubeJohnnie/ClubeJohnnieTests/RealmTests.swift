//
//  PersistenceTests.swift
//  AgileDashboard
//
//  Created by vinicius on 6/14/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import XCTest
@testable import ClubeJohnnie

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Class -
//
//----------------------------------------------------------------------------------------------------------

class RealmTests : ClubeJohnnieTests {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
//--------------------------------------------------
// MARK: - Create
//--------------------------------------------------
    
    func testCRUD_ByCreatingUserWithId_ShouldPersistUser() {
        let testUser = TestUser.create(withId: "123")
        XCTAssertNotNil(testUser)
        XCTAssertEqual(testUser!.testUserId, "123")
    }

//**************************************************
// MARK: - Fetch
//**************************************************
    
    func testCRUD_ByFetchingNotStoredUser_ShouldReturnEmptyData() {
        let testUser = TestUser.fetch(withId: "123")
        XCTAssertNil(testUser)
    }
    
//    func testCRUD_ByCreatingAndFetchingUserById_ShouldReturnConsistentUserFromDatabase() {
//        let id = "111"
//        let name = "John"
//        let age = 26
//        let expectation = self.expectationWithDescription("save user")
//        
//        let testUser = TestUser.create(withId: id) as! TestUser
//        testUser.age = age
//        testUser.name = name
//        TestUser.save { (error) in
//            let fetchedTestUser = TestUser.fetch(withId: id) as! TestUser
//            XCTAssertNotNil(fetchedTestUser)
//            XCTAssertEqual(fetchedTestUser.age, age)
//            XCTAssertEqual(fetchedTestUser.name, name)
//            expectation.fulfill()
//        }
//        
//        self.waitForExpectationsWithTimeout(10, handler: nil)
//    }
    
//    func testCRUD_ByFetchingAllUsers_ShouldReturnEmptyData() {
//        let allTestUsers = TestUser.fetchAll()
//        XCTAssertTrue(allTestUsers!.isEmpty)
//    }
    
//**************************************************
// MARK: - Fetch
//**************************************************
    
//    func testCRUD_ByFetchingNotStoredUser_ShouldReturnEmptyData() {
//        let expectation = self.expectationWithDescription("fetch not previously stored user")
//        
//        TestUser.fetch(withId: "SomeId") { (data, error) in
//            
//            XCTAssertNil(data)
//            expectation.fulfill()
//        }
//        
//        self.waitForExpectationsWithTimeout(10, handler: nil)
//    }
//    
//    func testCRUD_ByCreatingAndFetchingUserById_ShouldReturnConsistentUserFromDatabase() {
//        let expectation = self.expectationWithDescription("create and fetch test user")
//        let userId = "111"
//        let name = "John Doe"
//        let age = 10
//        
//        TestUser.create(withId: userId) { (data, error) in
//            
//            let user = data as! TestUser
//            user.age = age
//            user.name = name
//            user.save { (error) in
//                
//                TestUser.fetch(withId: userId, completion: { (data, error) in
//                    let user = data as! TestUser
//                    XCTAssertNil(error)
//                    XCTAssertNotNil(data)
//                    XCTAssertTrue(user.id == userId)
//                    XCTAssertTrue(user.name == name)
//                    XCTAssertTrue(user.age == age)
//                    expectation.fulfill()
//                })
//            }
//        }
//        
//        self.waitForExpectationsWithTimeout(10, handler: nil)
//    }
}
