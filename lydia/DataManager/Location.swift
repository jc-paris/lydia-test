//
//  Location.swift
//  lydia
//
//  Created by Jean-Christophe Paris on 29/08/2018.
//  Copyright © 2018 Jean-Christophe Paris. All rights reserved.
//

import Foundation
import CoreData

@objc(Location)
public class Location: NSManagedObject {
    
    @NSManaged public var street: String
    @NSManaged public var city: String
    @NSManaged public var state: String
    @NSManaged public var postcode: String
    @NSManaged public var latitude: Float
    @NSManaged public var longitude: Float
    @NSManaged public var timezone: String

    @NSManaged public var user: User

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }
}

extension Location {
    func fill(with result: LocationResult) {
        self.street = result.street
        self.city = result.city
        self.state = result.state
        self.postcode = result.postcode
        self.latitude = result.latitude
        self.longitude = result.longitude
        self.timezone = result.timezone
    }
}
