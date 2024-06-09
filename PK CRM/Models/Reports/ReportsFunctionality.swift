//
//  ReportsFunctionality.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 30/7/23.
//

import Foundation

class ReportsFunctionality{
    
    //MARK: Properties
    let calendar = Calendar.current

    //MARK: Functions
    func getCurrentYear()->Int{
          let currentDate = Date()
          let currentYear = calendar.component(.year, from: currentDate)
          return currentYear
    }
    
    func getFirstAndLastYearDay(_ year:Int) -> [Date]{
        let currentYear = year
        let dateComponents = DateComponents()
        var startDateComponents = dateComponents
        var lastDateComponents = DateComponents()

        startDateComponents.year = currentYear
        startDateComponents.month = 1
        startDateComponents.day = 1
        let startDate = calendar.date(from: startDateComponents)!
        
        lastDateComponents.year = currentYear
        lastDateComponents.month = 12
        lastDateComponents.day = 31
        let lastDate = calendar.date(from: lastDateComponents)!

        return [startDate,lastDate]
    }
}
