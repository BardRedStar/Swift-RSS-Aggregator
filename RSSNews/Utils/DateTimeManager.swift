//
//  DateTimeManager.swift
//  RSSNews
//
//  Created by User on 04/03/2019.
//  Copyright © 2019 Saritasa Inc. All rights reserved.
//

import Foundation
import UIKit

/// A class to date time operations
class DateTimeManager {

    /// Gets interval between two date objects with day precision
    ///
    /// - Parameters:
    ///   - calendar: Calendar object
    ///   - date1: First date to count from
    ///   - date2: Second date to count to
    /// - Returns: Date components which contains time interval
    class func intervalBetweenDatesWithDayPrecision(calendar: Calendar, from date1: Date, to date2: Date) -> DateComponents {
        return calendar.dateComponents([Calendar.Component.day,
                                 Calendar.Component.hour,
                                 Calendar.Component.minute,
                                 Calendar.Component.second],
                                       from: date1, to: date2)
    }

    /// Gets time in string elapsed from date object to current date-time
    ///
    /// - Parameters:
    ///   - pastDate: Date to count from
    ///   - calendar: Calendar object
    /// - Returns: Date interval string
    class func elapsedTime(from pastDate: Date?, calendar: Calendar = Calendar.current) -> String {

        if pastDate == nil {
            return "unknown"
        }

        let elapsedTime = intervalBetweenDatesWithDayPrecision(calendar: calendar, from: pastDate!, to: Date())

        if elapsedTime.day! > 0 || elapsedTime.hour! > 3 {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.timeZone = calendar.timeZone
            let format: String
            switch elapsedTime.day! {
            case 0:
                format = "'today at' HH:mm"
            case 1:
                format = "'yesterday at' HH:mm"
            case ...365:
                format = "dd MMM 'at' HH:mm"
            default:
                format = "dd MMM yyyy"
            }
            dateFormatter.dateFormat = format
            return dateFormatter.string(from: pastDate!)

        } else if elapsedTime.hour! > 0 && elapsedTime.hour! <= 3 {
            let literals = ["one", "two", "three"]
            let hours = elapsedTime.hour! < 4 ? literals[elapsedTime.hour! - 1] : String(elapsedTime.hour!)
            return "\(hours) \(elapsedTime.hour! == 1 ? "hour" : "hours") ago"
        } else if elapsedTime.minute! > 0 {
            return "\(elapsedTime.minute!) \(elapsedTime.minute! == 1 ? "minute" : "minutes") ago"
        } else {
            return "\(elapsedTime.second!) \(elapsedTime.second! == 1 ? "second" : "seconds") ago"
        }
    }

    /// Converts string formatted UTC time into date object
    ///
    /// - Parameter utcString: UTC String
    /// - Returns: Date object of UTF string
    class func convertUTCStringToDateFormat(from utcString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        if utcString.contains(".") {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSSZ"
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        }
        return dateFormatter.date(from: utcString)
    }

}
