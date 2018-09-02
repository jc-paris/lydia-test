//
//  CoreDataUnitTests.swift
//  lydiaUnitTests
//
//  Created by Jean-Christophe Paris on 25/08/2018.
//  Copyright © 2018 Jean-Christophe Paris. All rights reserved.
//

import XCTest
import CoreData
@testable import lydia
import SwiftyJSON

class CoreDataUnitTests: XCTestCase {
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "lydia")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false // Make it simpler in test env
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            precondition( description.type == NSInMemoryStoreType )
            
            if let error = error as NSError? {
                fatalError("Couldn't create in memory coordinator: \(error.localizedDescription)")
            }
        })
        return container
    }()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        let fetchRequest:NSFetchRequest<lydia.User> = lydia.User.fetchRequest()
        let objects = try! persistentContainer.viewContext.fetch(fetchRequest)
        for case let object as NSManagedObject in objects {
            persistentContainer.viewContext.delete(object)
        }
        try! persistentContainer.viewContext.save()
        super.tearDown()
    }
    
    var userResult: UserResult?
    
    fileprivate func createJSON() -> JSON {
        var json = JSON([:])
        json["login"].dictionaryObject = [:]
        json["login"]["uuid"].stringValue = "1"
        json["login"]["username"].stringValue = "jcp"
        json["login"]["password"].stringValue = "qwerty"
        json["name"].dictionaryObject = [:]
        json["name"]["first"].stringValue = "jc"
        json["name"]["last"].stringValue = "paris"
        json["name"]["title"].stringValue = "M"
        json["gender"].stringValue = "male"
        json["phone"].stringValue = "0630467690"
        json["email"].stringValue = "email@example.com"
        json["nat"].stringValue = "FR"
        json["dob"].dictionaryObject = [:]
        json["dob"]["date"].stringValue = "1993-06-16T12:30:00Z"
        json["picture"].dictionaryObject = [:]
        json["picture"]["large"].stringValue = "path/to/picture"
        json["location"].dictionaryObject = [:]
        json["location"]["street"].stringValue = "12 avenue du général leclerc"
        json["location"]["city"].stringValue = "paris"
        json["location"]["state"].stringValue = ""
        json["location"]["postcode"].intValue = 75014
        json["location"]["coordinates"].dictionaryObject = [:]
        json["location"]["coordinates"]["latitude"].stringValue = "48.833987"
        json["location"]["coordinates"]["longitude"].stringValue = "2.332628"
        json["location"]["timezone"].dictionaryObject = [:]
        json["location"]["timezone"]["offset"].stringValue = "+2:00"
        return json
    }
    
    // Test JSON parser
    func testUserResult() {
        let json = createJSON()
        guard let userResult = lydia.UserResult(json: json) else {
            XCTAssert(false, "Cannot created UserResult from JSON")
            return
        }
        XCTAssert(userResult.uuid == json["login"]["uuid"].string)
    }
    
    // Test fill method of CoreData object + CoreData validation on saving
    func testInsertUserResult() {
        let json = createJSON()
        guard let userResult = lydia.UserResult(json: json) else {
            XCTAssert(false, "userResult not created")
            return
        }
        let viewContext = persistentContainer.viewContext
        let user = lydia.User(context: viewContext)
        user.fill(with: userResult)
        let location = lydia.Location(context: viewContext)
        location.fill(with: userResult.location)
        user.location = location
        do {
            try viewContext.save()
        } catch let error {
            XCTAssert(false, "Cannot save context: \(error.localizedDescription) \(error)")
            return
        }
        let fetchRequest: NSFetchRequest<lydia.User> = lydia.User.fetchRequest()
        guard let fetchedUsers = try? viewContext.fetch(fetchRequest) else {
            XCTAssert(false, "Cannot execute fetch request")
            return
        }
        XCTAssert(fetchedUsers.count == 1)
        XCTAssert(user.uuid == fetchedUsers.first?.uuid)
    }
    
}
