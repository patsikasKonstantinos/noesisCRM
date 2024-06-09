//
//  DateExtensions.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 23/7/23.
//

import Foundation

extension Date {
    
    var day: String {
         let dayFormatter = DateFormatter()
         dayFormatter.dateFormat = "dd"
         return dayFormatter.string(from: self)
    }
    
    var hour: String {
         let hourFormatter = DateFormatter()
         hourFormatter.dateFormat = "h:mm a"
         return hourFormatter.string(from: self)
    }

    var dayName: String {
        let dayNameFormatter = DateFormatter()
        dayNameFormatter.dateFormat = "EEE"
        return dayNameFormatter.string(from: self)
    }
     
    var monthShort: String {
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM"
        return monthFormatter.string(from: self)
    }

    var year: String {
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        return yearFormatter.string(from: self)
    }
    
    func currentTimeMillis() -> Int64 {
           return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    func firstAndLastDateOfCurrentMonth() -> (firstDate: Date, lastDate: Date)? {
        let calendar = Calendar.current
        let currentDate = Date()
        
        // Get the year, month, and day components of the current date
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        
        // Create a date components object for the first day of the month
        var firstDayComponents = DateComponents()
        firstDayComponents.year = year
        firstDayComponents.month = month
        firstDayComponents.day = 1
        
        // Create a date components object for the next month's first day
        var nextMonthComponents = DateComponents()
        nextMonthComponents.year = year
        nextMonthComponents.month = month + 1
        nextMonthComponents.day = 1
        
        // Subtracting 1 second from the next month's first day will give the last day of the current month
        if let nextMonthDate = calendar.date(from: nextMonthComponents),
           let lastDate = calendar.date(byAdding: .second, value: -1, to: nextMonthDate),
           let firstDate = calendar.date(from: firstDayComponents) {
            return (firstDate, lastDate)
        }
        
        return nil
    }
}


