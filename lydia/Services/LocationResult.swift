//
//  LocationResult.swift
//  lydia
//
//  Created by Jean-Christophe Paris on 29/08/2018.
//  Copyright © 2018 Jean-Christophe Paris. All rights reserved.
//

import Foundation
import SwiftyJSON

struct LocationResult {
    
    var street: String
    var city: String
    var state: String
    var postcode: String
    var latitude: Float
    var longitude: Float
    var timezone: String
    
    init?(json: JSON) {
        guard let street = json["street"].string,
            let city = json["city"].string,
            let state = json["state"].string,
            json["postcode"].exists(),
            let latitudeString = json["coordinates"]["latitude"].string,
            let latitude = Float(latitudeString),
            let longitudeString = json["coordinates"]["longitude"].string,
            let longitude = Float(longitudeString),
            let timezone = json["timezone"]["offset"].string else {
                print("Skipping a location..")
                return nil
        }

        self.street = street
        self.city = city
        self.state = state
        if let postcode = json["postcode"].int {
            self.postcode = String(postcode)
        } else {
            self.postcode = json["postcode"].string ?? ""
        }
        self.latitude = latitude
        self.longitude = longitude
        self.timezone = timezone
    }
}
