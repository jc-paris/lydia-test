//
//  UserResult.swift
//  lydia
//
//  Created by Jean-Christophe Paris on 25/08/2018.
//  Copyright © 2018 Jean-Christophe Paris. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UserResult {
    var uuid: String
    var firstName: String
    var lastName: String
    var email: String
    var picture: String
    var gender: Gender
    var title: String
    var birthday: Date
    var pseudo: String
    var password: String
    var phone: String
    var nationality: Nationality
    var location: LocationResult
    
    init?(json: JSON) {
        guard let uuid = json["login"]["uuid"].string,
            let firstName = json["name"]["first"].string,
            let lastName = json["name"]["last"].string,
            let email = json["email"].string,
            let title = json["name"]["title"].string,
            let genderString = json["gender"].string,
            let gender = Gender(rawValue: genderString),
            let birthdayString = json["dob"]["date"].string,
            let birthday = Date.fromAPI(birthdayString),
            let phone = json["phone"].string,
            let nationalityString = json["nat"].string,
            let nationality = Nationality(rawValue: nationalityString),
            let pseudo = json["login"]["username"].string,
            let password = json["login"]["password"].string,
            let location = LocationResult(json: json["location"]),
            let picture = json["picture"]["large"].string else {
                print("Skipping a user..")
                return nil
        }
        self.uuid = uuid
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.picture = picture
        self.title = title
        self.gender = gender
        self.birthday = birthday
        self.phone = phone
        self.nationality = nationality
        self.pseudo = pseudo
        self.password = password
        self.location = location
    }
}
