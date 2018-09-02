//
//  UserDataManager.swift
//  lydia
//
//  Created by Jean-Christophe Paris on 25/08/2018.
//  Copyright © 2018 Jean-Christophe Paris. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class UserDataManager {
    static var shared = UserDataManager()
    
    var users: [User] = []
    
    func initialize() {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<User> = User.fetchRequest()
        do {
            self.users = try managedContext.fetch(request)
        } catch let error {
            print("failed to fetch coffee object: \(error)")
        }
    }
    
    func saveUserResults(_ results: [UserResult]) throws -> [User] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        var insertedUsers = [User]()
        for userResult in results {
            if users.filter({ $0.uuid == userResult.uuid }).count > 0 {
                continue
            }
            let cdUser = User(context: context)
            cdUser.fill(with: userResult)
            let cdLocation = Location(context: context)
            cdLocation.fill(with: userResult.location)
            cdUser.location = cdLocation
            users.append(cdUser)
            insertedUsers.append(cdUser)
        }
        
        if context.hasChanges {
            try context.save()
        }
        return insertedUsers
    }
}
