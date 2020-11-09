//
//  DateUtils.swift
//  RoyalCommission
//
//  Created by Mohamed Nassar on 2/5/19.
//  Copyright © 2019 KeyBS Mobile Devp All rights reserved.
//

import Foundation

public enum DateFormatType: String {
    /// "dd"
    case ONLY_DAY = "dd"
    /// "d"
    case ONLY_DAY_SMALL = "d"
    /// "EEEE"
    case DAY_TITLE_FULL = "EEEE"
    /// "E"
    case DAY_TITLE_SMALL = "E"
    /// "hh:mm a"
    case JUST_12HOURS_TIME = "hh:mm a"
    /// "dd/MM/yyyy hh:mm:a"
    case NORMAL_DATE_TIME = "dd/MM/yyyy hh:mm:a"
    /// "M/d/yyyy hh:mm:ss a"
    case EXPIRY_DATE_IN = "M/d/yyyy hh:mm:ss a"
    /// "yyyy-MM-dd hh:mm a"
    case yyyy_MM_dd_hh_mm_a = "yyyy-MM-dd hh:mm a"
    /// "yyyyMMdd"
    case DOB_DATE = "yyyyMMdd"
    /// "HH:mm:ss"
    case HH_mm_ss = "HH:mm:ss"
    /// "HH:mm"
    case HH_mm = "HH:mm"
    /// "dd/MM/yyyy"
    case UI_DATE_FORMAT = "dd/MM/yyyy"
    /// "yyyy-MM-dd HH:mm:ss"
    case DEFAULT_SERVER_DATE_TIME = "yyyy-MM-dd HH:mm:ss"
    /// "yyyy-MM-dd'T'HH:mm:ss"
    case DEFAULT_SERVER_DATE_TIME2 = "yyyy-MM-dd HH:mm"
    /// "yyyy-MM-dd'T'HH:mm"
    case DEFAULT = "yyyy-MM-dd'T'HH:mm:ss"
    /// "dd MMMM yyyy"
    case dd_MMMM_yyyy = "dd MMMM yyyy"
    /// "yyyy MM dd"
    case yyyy_MM_dd = "yyyy MM dd"
    /// "yyyy-MM-dd"
    case DEFAULT_SERVER_DATE = "yyyy-MM-dd"
    /// "dd-MM-yyyy"
    case dd_MM_yyyy_dashes = "dd-MM-yyyy"
    /// "d MMM yyyy"
    case d_MMM_yyyy_spaces = "d MMM yyyy"
    /// "MMMM yyyy"
    case MMMM_yyyy = "MMMM yyyy"
    /// "yyyy"
    case yyyy = "yyyy"
    /// "MM"
    case MM = "MM"
    /// "dd MMM"
    case dd_MMM = "dd MMM"
    /// "MMMM"
    case MMMM = "MMMM"
    /// "MMM dd, hh:mm a"
    case MMM_dd_hh_mm_a = "MMM dd, hh:mm a"
}

public struct DateUtils {
    public static var defaultLocale: Locale = Locale(identifier: "en_US_POSIX")
    public static var defaultTimeZone: TimeZone = TimeZone(secondsFromGMT: 0)!
    public static var defaultCalendarIdentifier: Calendar.Identifier = Calendar.Identifier.gregorian
    public static var defaultCalendar: Calendar = Calendar.init(identifier: DateUtils.defaultCalendarIdentifier)
    
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = DateUtils.defaultLocale
        formatter.timeZone = DateUtils.defaultTimeZone
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.isLenient = true
        return formatter
    }
    
    public static func stringFrom(optionalDate: Date?, usingDateFormatter dateFormatter: DateFormatter) -> String? {
        guard let safeDate = optionalDate else { return nil }
        return DateUtils.stringFrom(date: safeDate, usingDateFormatter: dateFormatter)
    }
    
    public static func stringFrom(optionalDate: Date?, usingDateFormat outputDateFormat: DateFormatType) -> String? {
        guard let safeDate = optionalDate else { return nil }
        return DateUtils.stringFrom(date: safeDate, usingDateFormat: outputDateFormat)
    }
    
    public static func stringFrom(date: Date, usingDateFormatter dateFormatter: DateFormatter) -> String {
        return dateFormatter.string(from: date)
    }
    
    public static func stringFrom(date: Date, usingDateFormat outputDateFormat: DateFormatType) -> String {
        let formatter = DateFormatter()
        formatter.locale = DateUtils.defaultLocale
        formatter.timeZone = DateUtils.defaultTimeZone
        formatter.isLenient = true
        
        formatter.dateFormat = outputDateFormat.rawValue
        return formatter.string(from: date)
    }
    
    public static func convert(dateString: String, withDateFormatOf inputDateFormat: DateFormatType, toDateFormatOf outputDateFormat: DateFormatType) -> String? {
        if let date = DateUtils.dateFrom(string: dateString, withDateFormatOf: inputDateFormat) {
            return DateUtils.stringFrom(date: date, usingDateFormat: outputDateFormat)
        } else {
            return nil
        }
    }

    public static func dateFrom(string: String, withDateFormatOf inputDateFormat: DateFormatType) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = DateUtils.defaultLocale
        formatter.timeZone = DateUtils.defaultTimeZone
        formatter.isLenient = true
        
        formatter.dateFormat = inputDateFormat.rawValue
        return formatter.date(from: string)
    }
    
    public static func ageFrom(dateString: String, inputDateFormatOfDateString: DateFormatType) -> String {
        let formatter = DateFormatter()
        formatter.locale = DateUtils.defaultLocale
        formatter.timeZone = DateUtils.defaultTimeZone
        formatter.isLenient = true
        
        formatter.dateFormat = inputDateFormatOfDateString.rawValue
        let birthday = formatter.date(from: dateString)!
        let now = Date()
        let calendar = DateUtils.defaultCalendar
        
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        let age = "\(String(describing: ageComponents.year ?? 0))"
        return age
    }
    
    public static func dateComponents(_ components: Set<Calendar.Component>, fromDate date: Date) -> DateComponents {
        let calendar = DateUtils.defaultCalendar
        let dateComponents = calendar.dateComponents(components, from: date)
        return dateComponents
    }
    
    // new date utils
    public static func compareDates(date1: Date, date2: Date) -> ComparisonResult {
        let order = DateUtils.defaultCalendar.compare(date1, to: date2, toGranularity: .day)
        return order
    }
    
    public static func isDateInRange(dateToCheck: Date, start: Date ,end: Date, includeTimeComponents: Bool = true) -> Bool {
        var dateToCheck: Date = dateToCheck
        var start: Date = start
        var end: Date = end
        // the date is either equal to first or last date, then its valid
        if !includeTimeComponents {
            dateToCheck = DateUtils.zeroOutTimeFromDate(date: dateToCheck)
            start = DateUtils.zeroOutTimeFromDate(date: start)
            end = DateUtils.zeroOutTimeFromDate(date: end)
        }
        if ((dateToCheck.compare(start) == .orderedSame) || (dateToCheck.compare(end) == .orderedSame)) {
            return true
        } else {
            // the date is bigger than first date but smaller than last date , then its valid
            if  dateToCheck.compare(start) == .orderedDescending {
                if dateToCheck.compare(end) == .orderedAscending {
                    return true
                }
            }
        }
        return false
    }
    
    public static func zeroOutTimeFromDate(date: Date) -> Date {
        let currentDateSeconds = DateUtils.defaultCalendar.component(.second, from: date)
        let currentDateMinutes = DateUtils.defaultCalendar.component(.minute, from: date)
        let currentDateHours = DateUtils.defaultCalendar.component(.hour, from: date)

        let currentDateRemovingSeconds = DateUtils.defaultCalendar.date(byAdding: .second, value: -currentDateSeconds, to: date)

        let currentDateRemovingMinutes = DateUtils.defaultCalendar.date(byAdding: .minute, value: -currentDateMinutes, to: currentDateRemovingSeconds!)

        let currentDateRemovingHours = DateUtils.defaultCalendar.date(byAdding: .hour, value: -currentDateHours, to: currentDateRemovingMinutes!)
        return currentDateRemovingHours!
    }
}
