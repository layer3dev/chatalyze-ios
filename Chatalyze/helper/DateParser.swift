//
//  DateParser.swift
//  ICS
//
//  Created by Sumant Handa on 09/04/16.
//  Copyright © 2016 MansaInfoTech. All rights reserved.
//

import UIKit

class DateParser: NSObject {
    
    static func parseToFormattedData(_ dateString : String)->String?{
        guard let date = stringToDate(dateString)
            else{
                return ""
        }
        
        guard let formattedDateString = dateToString(date)
            else{
                return ""
        }
        
        return formattedDateString
    }

    static func stringToDate(_ dateString : String)->Date?{
        let defaultFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
        return stringToDate(dateString, dateFormat: defaultFormat)
    }
    
    static func dateToString(_ date : Date)->String?{
        let defaultFormat = "MMM d, yyyy"
        return dateToString(date, requiredFormat : defaultFormat)
    }
    
    static func dateToStringInServerFormat(_ date : Date?)->String?{
        
        guard let dateUW = date
            else{
                return ""
        }
        let defaultFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let defaultTimeZone = TimeZone.autoupdatingCurrent
        return dateToString(dateUW, requiredFormat : defaultFormat, timeZone: defaultTimeZone)
    }
    
    static func stringToDate(_ dateString : String, dateFormat : String)->Date?{
        let defaultTimeZone = TimeZone.autoupdatingCurrent
        return stringToDate(dateString, dateFormat: dateFormat, timeZone: defaultTimeZone)
    }
    
    static func dateToString(_ date : Date?, requiredFormat : String)->String?{
       let defaultTimeZone = TimeZone.autoupdatingCurrent
        return dateToString(date, requiredFormat: requiredFormat, timeZone: defaultTimeZone)
    }
    
    
    static func stringToDate(_ dateString : String, dateFormat : String, timeZone : TimeZone)->Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier : "en_US_POSIX")
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = timeZone
        return dateFormatter.date(from: dateString)
    }
    
    static func UTCStringToDate(_ dateString : String)->Date?{
        let defaultFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
        let UTCTimeZone = TimeZone(abbreviation : "UTC") ?? TimeZone.current
        return stringToDate(dateString, dateFormat: defaultFormat, timeZone: UTCTimeZone)
    }
    
    static func dateToString(_ date : Date?, requiredFormat : String, timeZone : TimeZone)->String?{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier : "en_US_POSIX")
        dateFormatter.dateFormat = requiredFormat
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: date ?? Date())
    }
    
    static func getDateComponentsFromDate(_ date : Date?)->DateComponents{
        let calendar = Calendar.current
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .month, .year, .weekday]
        return (calendar as NSCalendar).components(unitFlags, from: date ?? Date())
    }
    

    
    
}
