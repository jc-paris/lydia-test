//
//  Date+APIFormat.swift
//  lydia
//
//  Created by Jean-Christophe Paris on 29/08/2018.
//  Copyright © 2018 Jean-Christophe Paris. All rights reserved.
//

import Foundation

extension Date {
    static func fromAPI(_ api: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: api)
    }
}
