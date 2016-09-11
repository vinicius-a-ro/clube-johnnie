//
//  PersistenceTests.swift
//  AgileDashboard
//
//  Created by vinicius on 6/14/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import XCTest
import RealmSwift
@testable import ClubeJohnnie

//----------------------------------------------------------------------------------------------------------
//
// MARK: - Class -
//
//----------------------------------------------------------------------------------------------------------

class RealmTests : ClubeJohnnieTests {
    
    override func setUp() {
        super.setUp()
        self.setupDatabase()
        self.clearDatabase()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func setupDatabase() {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = "\(self.name)\(NSDate())"
    }
    
    func clearDatabase() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    var jsonData: NSData {
        let bundle = NSBundle(forClass: JSONTests.self)
        let filePath = bundle.pathForResource("Friends", ofType: "json")
        return NSData(contentsOfFile: filePath!)!
    }
    
    var friendsJson: JSON {
        return JSON(data: self.jsonData)
    }
    
    lazy var friends: [TestUser] = {
        var friends: [TestUser] = []
        for info in self.friendsJson["friends"].arrayValue {
            let friend = TestUser()
            friend.age = info["user"]["age"].intValue
            friend.testUserId = info["user"]["testUserId"].stringValue
            friend.name = info["user"]["name"].stringValue
            friends.append(friend)
        }
        return friends
    }()
    
//--------------------------------------------------
// MARK: - Create
//--------------------------------------------------
    
    func testCRUD_ByCreatingUserWithId_ShouldPersistUser() {
        let testUser = TestUser.dataAccess.create(withId: "123")
        XCTAssertNotNil(testUser)
        XCTAssertEqual(testUser!.testUserId, "123")
    }

//--------------------------------------------------
// MARK: - Fetch
//--------------------------------------------------
    
    func testCRUD_ByFetchingNotStoredUser_ShouldReturnEmptyData() {
        let testUser = TestUser.dataAccess.fetch(withId: "123")
        XCTAssertNil(testUser)
    }

    func testCRUD_ByCreatingAndFetchingUserById_ShouldReturnConsistentUserFromDatabase() {
        let id = "111"
        let name = "John"
        let age = 26
        let expectation = self.expectationWithDescription("save user")
        
        let testUser = TestUser.dataAccess.create(withId: id)!
        testUser.age = age
        testUser.name = name
        TestUser.dataAccess.save([testUser]) { (savedObjects, error) in
            let fetchedTestUser = TestUser.dataAccess.fetch(withId: id)!
            XCTAssertNotNil(fetchedTestUser)
            XCTAssertEqual(fetchedTestUser.age, age)
            XCTAssertEqual(fetchedTestUser.name, name)
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testCRUD_ByFetchingAllUsers_ShouldReturnEmptyData() {
        let allTestUsers = TestUser.dataAccess.fetchAll()
        XCTAssertTrue(allTestUsers.isEmpty)
    }
    
    func testCRUD_BySavingAndFetchingAllUsers_ShouldReturnFullFriendsData() {
        TestUser.dataAccess.save(self.friends) { (savedObjects, error) in
            let allTestUsers = TestUser.dataAccess.fetchAll()
            XCTAssertEqual(allTestUsers.count, savedObjects.count)
            XCTAssertEqual(allTestUsers.count, self.friends.count)
        }
    }
    
    func testCRUD_ByFetchingAllUsersWithAscendingSortKeys_ShouldReturnSortedObject() {
        TestUser.dataAccess.save(self.friends) { (_, _) in
            let allTestUsers = TestUser.dataAccess.fetchAll([SortKey.Ascending("testUserId")])
            let firstUser = allTestUsers.first!
            let lastUser = allTestUsers.last!
            XCTAssertTrue(firstUser.testUserId < lastUser.testUserId)
        }
    }
    
    func testCRUD_ByFetchingAllUsersWithDescendingSortKeys_ShouldReturnSortedObject() {
        TestUser.dataAccess.save(self.friends) { (_, _) in
            let allTestUsers = TestUser.dataAccess.fetchAll([SortKey.Descending("testUserId")])
            let firstUser = allTestUsers.first!
            let lastUser = allTestUsers.last!
            XCTAssertTrue(firstUser.testUserId > lastUser.testUserId)
        }
    }
    
    func testCRUD_ByUpdatingFetchedObject_ShouldNotRaiseNotInWriteTransactionException() {
        let expectation = self.expectationWithDescription("save user")
        let id = "111"
        let testUser = TestUser.dataAccess.create(withId: id)!
        
        TestUser.dataAccess.save([testUser]) { (savedObjects, error) in
            let fetchedTestUser = TestUser.dataAccess.fetch(withId: id)!
            fetchedTestUser.age = 27
            fetchedTestUser.name = "John Doe"
            
            TestUser.dataAccess.save([fetchedTestUser]) { (savedObjects, error) in
                expectation.fulfill()
                XCTAssertNil(error)
            }
        }
        
        self.waitForExpectationsWithTimeout(10, handler: nil)
    }

    func testCRUD_BySavingBatchUsers_ShouldStoreSavedInformation() {
        TestUser.dataAccess.save(self.friends) { (savedObjects, error) in
            XCTAssertNil(error)
            
            for friend in self.friends {
                XCTAssertFalse(friend.name.isEmpty)
                XCTAssertFalse(friend.testUserId.isEmpty)
            }
        }
    }
    
    func testCRUD_BySavingBatchUsers_ShouldNotRaiseRealmExceptionWhenEditingSavedObjects() {
        let expectation = self.expectationWithDescription(#function)
        let friends = self.friends
        
        TestUser.dataAccess.save(friends) { (friends, error) in
            XCTAssertNil(error)

            for friend in friends {
                friend.verified = true
            }
            TestUser.dataAccess.save(friends) { (error) in
                XCTAssertEqual(friends.filter({ $0.verified == true }).count, friends.count)
                expectation.fulfill()
            }
        }
        
        self.waitForExpectationsWithTimeout(10, handler: nil)
    }

    func testCRUD_BySavingObject_ShouldHoldIgnoredPropertiesValues() {
        let testUser = TestUser.dataAccess.create(withId: "123")!
        testUser.someNotStoredProperty = "Some Value"

        TestUser.dataAccess.save([testUser]) { (savedObjects, error) in
            let savedTestUser = savedObjects.first!
            XCTAssertEqual(savedTestUser.someNotStoredProperty, "Some Value")
        }
    }
    
    func testCRUD_BySavingObject_ShouldHoldIgnoredPropertiesValue123123s() {
        let profilePictureURL = "http://lorempixel.com/600/600/business/"
        let multimediaItem = TestMultimediaItem.dataAccess.create(withId: profilePictureURL)!
        
        TestMultimediaItem.dataAccess.save([multimediaItem]) { (savedObjects, error) in
            XCTAssertNil(error)
        }
    }
    
    func testCRUD_BySavingObjectWithOtherObjectAsProperty_ShouldSaveChildObject() {
        let profilePictureURL = "http://lorempixel.com/600/600/business/"
        let testUser = TestUser.dataAccess.create(withId: "123")!
        let multimediaItem = TestMultimediaItem.dataAccess.create(withId: profilePictureURL)!
        testUser.profilePicture = multimediaItem
        
        TestUser.dataAccess.save([testUser]) { (savedObjects, error) in
            let fetchedTestUser = TestUser.dataAccess.fetch(withId: "123")
            XCTAssertNotNil(fetchedTestUser?.profilePicture)
            XCTAssertEqual(fetchedTestUser?.profilePicture?.objectId, profilePictureURL)
        }
    }
    
    func testCRUD_BySavingObjectWithOtherObjectAsProperty_ShouldAllowChildObjectEditing() {
        let profilePictureURL = "http://lorempixel.com/600/600/business/"
        let testUser = TestUser.dataAccess.create(withId: "123")!
        let multimediaItem = TestMultimediaItem.dataAccess.create(withId: profilePictureURL)!
        testUser.profilePicture = multimediaItem
        
        TestUser.dataAccess.save([testUser]) { (savedObjects, error) in
            
            let fetchedTestUser = TestUser.dataAccess.fetch(withId: "123")!
            fetchedTestUser.profilePicture?.remoteURL = profilePictureURL
            
            TestUser.dataAccess.save([fetchedTestUser]) { (_ , error) in
                XCTAssertNil(error)
            }
        }
    }
}
