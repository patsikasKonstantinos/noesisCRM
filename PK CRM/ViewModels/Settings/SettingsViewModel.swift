//
//  SettingsViewModel.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 3/8/23.
//

import Foundation
import RealmSwift

class SettingsViewModel:ObservableObject {
    
    //MARK: Published Properties
    @Published var currentDay = Date()
    @Published var appAppearance:AppAppearance
    @Published var id:Bool
    @Published var activeMenu:[AppMenu:Bool]
    @Published var selectedProjectStatus:Int = 1
    
    //MARK: let Properties
    let settingsFunctionality = SettingsFunctionality()
    
    //MARK: var Properties
    private var notificationToken:NotificationToken?
    var allCalls = RealmManager.shared.realm.objects(Calls.self)
    var allMeetings = RealmManager.shared.realm.objects(Meetings.self)
    var allPayments = RealmManager.shared.realm.objects(Payments.self)
    var allContacts = RealmManager.shared.realm.objects(Contacts.self)
    var allProjects = RealmManager.shared.realm.objects(Projects.self)
    var allDynamicForms = RealmManager.shared.realm.objects(DynamicForms.self)
    
    var projects: [Projects] {
        //All
        if selectedProjectStatus == 0 {
            return Array(allProjects.sorted(byKeyPath: "finishDate", ascending: true).prefix(10))
        }else{
            //Opened
            return Array(allProjects.filter("status = %@", 0).sorted(byKeyPath: "finishDate", ascending: true).prefix(10))
        }
    }
    
    var dynamicForms: [DynamicForms] {
        return Array(allDynamicForms.sorted(byKeyPath: "name", ascending: true))
    }
    
    var contacts:(customers: Int, suppliers: Int , employees:Int) {
        let customersCount = allContacts.filter("type = %@", 0).count
        let suppliersCount = allContacts.filter("type = %@", 1).count
        let employeesCount = allContacts.filter("type = %@", 2).count
        return (customersCount,suppliersCount,employeesCount)
    }
    
    var callsCount:Int {
        return allCalls.count
    }
    
    var dates: (firstDate: Date, lastDate: Date)? {
        if let dates = Date().firstAndLastDateOfCurrentMonth() {
            return (dates.firstDate,dates.lastDate)
        }
        return nil
    }
    
    var filteredIncomes:String {
        if let currDate = dates {
            let totalPrice = Array(allPayments.filter("date >= %@ AND date <= %@ AND isIncome = %@ AND isExpenses = %@", currDate.firstDate,currDate.lastDate,true,false)).reduce(0) { $0 + $1.price }
            return String(totalPrice).replacingOccurrences(of: ",", with: ".")
        }
        return "0.0"
    }
    
    var filteredExpenses:String {
        if let currDate = dates {
            let totalPrice = Array(allPayments.filter("date >= %@ AND date <= %@ AND isIncome = %@ AND isExpenses = %@", currDate.firstDate,currDate.lastDate,false,true)).reduce(0) { $0 + $1.price }
            return String(totalPrice).replacingOccurrences(of: ",", with: ".")
        }
        return "0.0"
    }
        
    var filteredMeetingsCount:Int {
        if let currDate = dates {
            return allMeetings.filter("date >= %@ AND date <= %@", currDate.firstDate,currDate.lastDate).count
        }
        return 0
    }
    
    //MARK: Initialization
    init() {
        self.appAppearance = settingsFunctionality.getAppAppearance()
        self.activeMenu = settingsFunctionality.getAppActiveMenu()
        self.id = false
        notificationToken = RealmManager.shared.realm.observe { [weak self] (_ ,_)  in
            self?.objectWillChange.send()
        }
    }
 
    //MARK: Functions
    func findProjectStatusColor(_ status:Int) -> AppColors {
        var color:AppColors
        if status == 1 || status == 2 || status == 3 {
             color = Variables.projectStatusColorsV2[status]!
        }else{
             color = Variables.projectStatusColorsV2[0]!
        }
        return color
    }
    
    func setAppAppearance(_ appearance:AppAppearance){
        self.appAppearance = appearance
        settingsFunctionality.setAppAppearance(appearance)
    }
    
    func setAppActiveMenu(_ activeMenu:[AppMenu:Bool]){
        settingsFunctionality.setAppActiveMenu(activeMenu)

    }
}
