//
//  UserViewModel.swift
//  lydia
//
//  Created by Jean-Christophe Paris on 25/08/2018.
//  Copyright © 2018 Jean-Christophe Paris. All rights reserved.
//

import Foundation
import PhoneNumberKit
import Contacts
struct UserViewModel {
    fileprivate var user: User
    
    var name: String { return "\(user.firstName.capitalized) \(user.lastName.capitalized)" }
    var email: String { return user.email }
    var gender: Gender { return Gender(rawValue: user.gender)! }
    var birthday: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        let years = Calendar.current.dateComponents([Calendar.Component.year], from: user.birthday, to: Date()).year!
        return "\(dateFormatter.string(from: user.birthday)) (\(years) yrs)"
    }
    var phone: String {
        let phoneNumberKit = PhoneNumberKit()
        guard let phoneNumber = try? phoneNumberKit.parse(user.phone, withRegion: user.nationality.lowercased(), ignoreType: true) else {
            return user.phone
        }
        print("<< \(user.phone) >> \(phoneNumberKit.format(phoneNumber, toType: .international))")
        return phoneNumberKit.format(phoneNumber, toType: .international)
    }
    var pseudo: String { return user.pseudo }
    var password: String { return user.password }
    var address: String {
        let postalAddress = CNMutablePostalAddress()
        postalAddress.street = user.location.street.capitalized
        postalAddress.city = user.location.city.capitalized
        postalAddress.state = user.location.state.capitalized
        postalAddress.postalCode = user.location.postcode
        
        let addressFormatter = CNPostalAddressFormatter()
        addressFormatter.style = .mailingAddress
        return addressFormatter.string(from: postalAddress)
    }
    func currentTime(showSeparators: Bool) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.from(ISO8601: user.location.timezone)
        dateFormatter.dateFormat = showSeparators ? "HH:mm:ss" : "HH mm ss"
        return dateFormatter.string(from: Date())
    }
    var picture: String { return user.picture }
    var latitude: Float { return user.location.latitude }
    var longitude: Float { return user.location.longitude }
    var flag: String {
        let base = 127397
        var unicodeScalarView = String.UnicodeScalarView()
        for i in user.nationality.utf16 {
            unicodeScalarView.append(UnicodeScalar(base + Int(i))!)
        }
        return String(unicodeScalarView)
    }
    init(user: User) {
        self.user = user
    }
}
