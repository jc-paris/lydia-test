//
//  User+CoreDataClass.swift
//  lydia
//
//  Created by Jean-Christophe Paris on 25/08/2018.
//  Copyright © 2018 Jean-Christophe Paris. All rights reserved.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    @NSManaged public var uuid: String
    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    @NSManaged public var title: String
    @NSManaged public var gender: String
    
    @NSManaged public var birthday: Date
    
    @NSManaged public var email: String
    @NSManaged public var pseudo: String
    @NSManaged public var password: String
    
    @NSManaged public var phone: String
    @NSManaged public var nationality: String
    @NSManaged public var picture: String
    
    @NSManaged public var location: Location

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }
}

extension User {
    func fill(with result: UserResult) {
        self.uuid = result.uuid
        self.firstName = result.firstName
        self.lastName = result.lastName
        self.email = result.email
        self.gender = result.gender.rawValue
        self.title = result.title
        self.birthday = result.birthday
        self.pseudo = result.pseudo
        self.password = result.password
        self.phone = result.phone
        self.nationality = result.nationality.rawValue
        self.picture = result.picture
    }
}
