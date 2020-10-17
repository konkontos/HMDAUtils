//
//  HMDADateUtils.swift
//  HMDAUtils
//  
//
//  Created by Konstantinos Kontos on 17/10/20.
//

import Foundation

public extension Date {
    
    static var autoupdatingFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.calendar = Calendar.autoupdatingCurrent
        
        return formatter
    }
    
    var memberSinceDateStr: String {
        let outputFormatter = Date.autoupdatingFormatter
        outputFormatter.dateFormat = "MMMM, yyyy"
        
        return outputFormatter.string(from: self)
    }
    
    var formattedServerDateShortStr: String {
        let outputFormatter = Date.autoupdatingFormatter
        outputFormatter.dateFormat = "dd/MM/yyyy"
        
        return outputFormatter.string(from: self)
        
    }
    
    var formattedServerDateStr: String {
        let outputFormatter = Date.autoupdatingFormatter
        outputFormatter.dateFormat = "dd MMMM, yyyy HH:mm"
        
        return outputFormatter.string(from: self)
    }
    
    var year: Int? {
        let dateComponents = Calendar.autoupdatingCurrent.dateComponents(in: TimeZone.current, from: self)
        return dateComponents.year
    }
    
    
    func dateOnlyStr(dateStyle: DateFormatter.Style) -> String {
        
        return { () -> DateFormatter in
            let fmt = Date.autoupdatingFormatter
            fmt.dateStyle = dateStyle
            fmt.timeStyle = .none
            return fmt
            }().string(from: self)
        
    }
    
}
