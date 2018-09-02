//
//  TimeZone+ISO8601.swift
//  lydia
//
//  Created by Jean-Christophe Paris on 29/08/2018.
//  Copyright © 2018 Jean-Christophe Paris. All rights reserved.
//

import Foundation

extension TimeZone {
    static func from(ISO8601: String) -> TimeZone {
        let dateFormmatter = DateFormatter()
        dateFormmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeZoneDateString = "\(dateFormmatter.string(from: Date())) GMT\(ISO8601)"
        
        let localTimeZoneFormatter = DateFormatter()
        localTimeZoneFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
        let timeZoneDate = localTimeZoneFormatter.date(from: timeZoneDateString)!
        
        let calendar = NSCalendar.current
        var seconds = calendar.dateComponents([.second], from: timeZoneDate, to: Date()).second!
        seconds += TimeZone.current.secondsFromGMT()
        
        return TimeZone(secondsFromGMT: seconds)!
    }
}
