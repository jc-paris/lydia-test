//
//  UserViewModelTests.swift
//  lydiaUnitTests
//
//  Created by Jean-Christophe Paris on 02/09/2018.
//  Copyright © 2018 Jean-Christophe Paris. All rights reserved.
//

import XCTest
import CoreData
@testable import lydia

class UserViewModelTests: XCTestCase {
    
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
    
    var user: lydia.User!
    
    override func setUp() {
        super.setUp()
        user = lydia.User(context: persistentContainer.viewContext)
        user.firstName = "jc"
        user.lastName = "paris"
        user.nationality = "FR"
        user.birthday = Date(timeIntervalSince1970: 740181600) // 16/06/1993
        user.phone = "0630467690"
        user.location = lydia.Location(context: persistentContainer.viewContext)
        user.location.street = "12 avenue du général leclerc"
        user.location.city = "paris"
        user.location.postcode = "75014"
        user.location.state = "île-de-france"
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testName() {
        let viewModel = UserViewModel(user: user)
        XCTAssert(viewModel.name == "Jc Paris", "Name incorrect: \(viewModel.name)")
    }

    func testFlag() {
        let viewModel = UserViewModel(user: user)
        XCTAssert(viewModel.flag == "🇫🇷", "Flag incorrect: \(viewModel.flag)")
    }
    
    func testBirthday() {
        let viewModel = UserViewModel(user: user)
        XCTAssert(viewModel.birthday == "16/06/1993 (25 yrs)", "Birthday incorrect: \(viewModel.birthday)")
    }
    
    func testPhone() {
        let viewModel = UserViewModel(user: user)
        XCTAssert(viewModel.phone == "+33 6 30 46 76 90", "Phone incorrect: \(viewModel.phone)")
    }
    
    func testAddress() {
        let viewModel = UserViewModel(user: user)
        XCTAssert(viewModel.address == "12 Avenue Du Général Leclerc\nParis Île-De-France 75014", "Address incorrect: \(viewModel.address)")
    }
}
