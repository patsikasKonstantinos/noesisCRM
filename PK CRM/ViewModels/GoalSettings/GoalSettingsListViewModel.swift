//
//  GoalSettingsListViewModel.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 16/6/23.
//

import Foundation
import RealmSwift

class GoalSettingsListViewModel: ObservableObject {
    @ObservedResults(GoalSettings.self) var allGoalSettings
    
    //MARK: Published Properties
    @Published var shouldUpdateList:Bool = false
    @Published var selectedGoalSetting = 0
    @Published var showingAddNewGoalSettingSheet = false
    @Published var editExistedGoalSettingSheet = false
    @Published var goalSettingsID: ObjectId?
    @Published var searchText = ""
    @Published var listCount:Int = 0
    @Published var addNewEntry = false
    
    //MARK: let Properties
    private let goalSettingsFunctionality: GoalSettingsFunctionality
    
    //MARK: var Properties
    private var notificationToken:NotificationToken?
    
    var goalSettings: [GoalSettings] {
        return Array(allGoalSettings.sorted(byKeyPath: "endDate", ascending: false))
    }
    
    var filteredGoalSettings: [GoalSettings] {
        if searchText.isEmpty {
            return goalSettings
        }
        else {
            return goalSettings.filter { goalSettings in
                goalSettingsFunctionality.findGoalSettings(searchText: searchText, goalSettings)
            }
        }
    }
 
    //MARK: Initialization
    init(goalSettingsFunctionality: GoalSettingsFunctionality) {
        self.goalSettingsFunctionality = goalSettingsFunctionality
        notificationToken = RealmManager.shared.realm.observe { [weak self] (_ ,_)  in
            self?.objectWillChange.send()
        }
    }
    
    deinit {
        // Invalidate the token when the object is deallocated
        notificationToken?.invalidate()
    }

    //MARK: Functions
    func updateListId(){
        shouldUpdateList.toggle()
        listCount = allGoalSettings.count
    }
    
    func changeDateFormat(date: Date) -> String {
        return goalSettingsFunctionality.changeDateFormat(date: date)
    }
    
    func deleteGoalSetting(offsets: IndexSet) {
        let index = offsets[offsets.startIndex]
        let goalSettingsId = goalSettings[index].id
        goalSettingsFunctionality.deleteGoalSettings(goalSettingsId)
        updateListId()
    }
}
