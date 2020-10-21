//
//  HMDADateUtils.swift
//  HMDAUtils
//  
//
//  Created by Konstantinos Kontos on 17/10/20.
//
// Inspired by original code at: https://github.com/malcommac/SwiftDate

import Foundation

public class HMDADate {
    
    /// Encapsulates common date formats
    public enum DateFormat: String {
        case simpleDateOnly = "dd/MM/yyyy"
        case simpleDateTime = "dd/MM/yyyy HH:mm"
        case full = "dd MMMM, yyyy HH:mm"
        case fullWeekday = "EEEE dd MMMM, yyyy HH:mm"
        case iso8601DateOnly = "YYYY-MM-dd"
        case iso8601DateTime = "YYYY-MM-dd HH:mm:ss"
        
        
        /// Returns a date formatter for the specified case
        /// - Parameter region: a DateRegion struct
        /// - Returns: a DateFormatter with local,
        /// timezone according to the specified date region
        public func formatter(in region: DateRegion = DateRegion()) -> DateFormatter {
            let formatter = DateFormatter()
            formatter.timeZone = region.timezone
            formatter.locale = region.locale
            formatter.dateFormat = self.rawValue
            return formatter
        }
        
    }
    
    
    /// A struct that groups a calendar,
    /// a timezone and a locale into a logical unit.
    public struct DateRegion {
        public var calendar = Calendar.autoupdatingCurrent
        public var timezone = TimeZone.current
        public var locale = Locale.current
        
        public init(calendar: Calendar = Calendar.autoupdatingCurrent, timezone: TimeZone = TimeZone.current, locale: Locale = Locale.current) {
            self.calendar = calendar
            self.timezone = timezone
            self.locale = locale
        }
        
        
        /// Convenience that returns a DateRegion configured
        /// for current autoupdating calendar, locale and timezone.
        /// - Returns: DateRegion
        public static func defaultRegion() -> DateRegion {
            DateRegion()
        }
        
    }

    
    /// A struct that groups a DateRegion
    /// and a Date into a logical unit.
    ///
    /// It provides core date calculation utilities.
    public struct DateInRegion {
        
        public var date = Date()
        public var region = DateRegion()
     
        public init(date: Date = Date(), region: DateRegion = DateRegion()) {
            self.date = date
            self.region = region
        }
        
        public static var defaultFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .full
            formatter.timeStyle = .full
            formatter.timeZone = TimeZone.autoupdatingCurrent
            formatter.locale = Locale.autoupdatingCurrent
            return formatter
        }
        
        public func isInPast(granularity: Calendar.Component = .nanosecond) -> Bool {
            (region.calendar.dateComponents([granularity], from: date, to: Date()).value(for: granularity) ?? 0 > 0)
        }
        
        public func isInFuture(granularity: Calendar.Component = .nanosecond) -> Bool {
            (region.calendar.dateComponents([granularity], from: date, to: Date()).value(for: granularity) ?? 0 < 0)
        }
        
        public func advanced(by granularity: Calendar.Component = .nanosecond, value: Int = 1) -> DateInRegion {
            DateInRegion(date: (region.calendar
                                    .date(byAdding: granularity, value: value, to: date) ?? date),
                         region: region)
        }
        
        public func difference(to targetDate: DateInRegion = DateInRegion(), granularity: Calendar.Component = .nanosecond) -> Int {
            region.calendar.dateComponents([granularity], from: self.date, to: targetDate.date).value(for: granularity) ?? 0
        }
        
        public func formattedStr(formatter: DateFormatter = DateInRegion.defaultFormatter) -> String {
            formatter.string(from: self.date)
        }
        
    }
    
}

public extension HMDADate.DateInRegion {
    
    static func regionalDate(from dateComponents: DateComponents, in region: HMDADate.DateRegion = HMDADate.DateRegion.defaultRegion()) -> HMDADate.DateInRegion {
        var regionalDate = HMDADate.DateInRegion()
        regionalDate.region = region
        regionalDate.date = region.calendar.date(from: dateComponents) ?? regionalDate.date
        
        return regionalDate
    }
    
    func isInSameWeek(with targetDate: HMDADate.DateInRegion) -> Bool {
        (difference(to: targetDate, granularity: .weekOfYear) == 0)
    }
    
    func isInSameMonth(with targetDate: HMDADate.DateInRegion) -> Bool {
        (difference(to: targetDate, granularity: .month) == 0)
    }
    
    func isInSameYear(with targetDate: HMDADate.DateInRegion) -> Bool {
        (difference(to: targetDate, granularity: .year) == 0)
    }

    func isInToday(with targetDate: HMDADate.DateInRegion) -> Bool {
        region.calendar.isDateInToday(targetDate.date)
    }
    
    func isInTomorrow(with targetDate: HMDADate.DateInRegion) -> Bool {
        region.calendar.isDateInTomorrow(targetDate.date)
    }
    
    func isInYesterday(with targetDate: HMDADate.DateInRegion) -> Bool {
        region.calendar.isDateInYesterday(targetDate.date)
    }
    
    var isWeekend: Bool {
        region.calendar.isDateInWeekend(self.date)
    }
    
}

public extension Date {
    
    
    /// Convenience method to convert a Date into a DateInRegion
    /// - Parameter region: DateRegion
    /// - Returns: DateInRegion
    func regionalDate(in region: HMDADate.DateRegion = HMDADate.DateRegion.defaultRegion()) -> HMDADate.DateInRegion {
        HMDADate.DateInRegion(date: self, region: region)
    }
    
}
