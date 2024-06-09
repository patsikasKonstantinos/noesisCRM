//
//  CalendarViewModel.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 17/6/23.
//

import Foundation

class CalendarViewModel: ObservableObject {
    
    //MARK: Published Properties
    @Published var displayedMonth: Date = Date()
    @Published var selectedDate: Date = Date()
    @Published var daysOff: [Date: Bool] = [:]
    @Published var showDayOffSheet: Bool = false
    @Published var activeDayOff:[Date:Bool] = [:]
    
    
    //MARK: let Properties
    private let daysOffFunctionality: DaysOffFunctionality
    
    let calendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Set Monday as the first day of the week
        return calendar
    }()

    let europeanDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()

    let monthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()

    let calendarWeekDays: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    //MARK: var Properties
    var displayedMonthString: String {
        monthYearFormatter.string(from: displayedMonth)
    }

    var weekdayNames: [String] {
        calendarWeekDays
    }

    var datesInMonth: [Date] {
        getDatesInMonth()
    }
    
    //MARK: Initialization
    init(daysOffFunctionality: DaysOffFunctionality) {
        self.daysOffFunctionality = daysOffFunctionality
    }
 
    //MARK: Functions
    func updateActiveDaysOff(_ date:Date){
        daysOff[date] = daysOffFunctionality.existDaysOffUserFromSpecificDate(date)
    }
    
    func changeMonth(by value: Int) {
        displayedMonth = calendar.date(byAdding: .month, value: value, to: displayedMonth) ?? Date()
    }

    func setup(){
        // Perform your logic to fetch the days off here
        // Update the `daysOff` dictionary accordingly
    }

    func selectDate(_ date: Date) {
        selectedDate = date
        showDayOffSheet = true
    }

    func backgroundColor(for date: Date) -> AppColors {
        let isActiveDayOff = daysOff[date] ?? false
        let isWithinDisplayedMonth = calendar.isDate(date, equalTo: displayedMonth, toGranularity: .month)

        if isActiveDayOff {
            return isWithinDisplayedMonth ? .orangeOpacity03 : .clear
        }
        else {
            return isWithinDisplayedMonth ? .greenOpacity03 : .clear
        }
    }

    func foregroundColor(for date: Date) -> AppColors {
        let isWithinDisplayedMonth = calendar.isDate(date, equalTo: displayedMonth, toGranularity: .month)
        return isWithinDisplayedMonth ? .black : .gray
    }

    private func getDatesInMonth() -> [Date] {
        var dates: [Date] = []
        let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: displayedMonth))!
        let firstDayOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: startDate))!
        var currentDate = firstDayOfWeek

        for _ in 0..<42 {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return dates
    }
}
