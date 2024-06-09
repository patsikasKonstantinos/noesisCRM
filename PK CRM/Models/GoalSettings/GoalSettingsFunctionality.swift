//
//  GoalSettingsFunctionality.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 2/10/22.
//

import Foundation
import RealmSwift

class GoalSettingsFunctionality:ObservableObject{
    
    //MARK: Properties
    let realm = RealmManager.shared.realm
    let projectsFunctionalityObj = ProjectsFunctionality()
    let dateFormatter = DateFormatter()
    
    //MARK: Functions
    func convertGoalSettingsArrayToList(_ array:[GoalSettings]) -> List<GoalSettings> {
         let list = List<GoalSettings>()
         list.append(objectsIn: array)
         return list
    }

    //Return GoalSettings
    func findGoalSettings() -> Results<GoalSettings> {
        let goalSettings = realm.objects(GoalSettings.self).sorted(byKeyPath: "firstName", ascending: true)
        return goalSettings
    }
    
    //Return Specific GoalSetting Id
    func findGoalSettings(_ goalSettingId:ObjectId) -> Results<GoalSettings>  {
        let allGoalSettingsObj = realm.objects(GoalSettings.self)
        let goalSettingFound = allGoalSettingsObj.where {
            $0.id == goalSettingId
        }
        return goalSettingFound
    }
    
    //Return Specific GoalSetting Id
    func findGoalSettingsArrayFormat(_ goalSettingId:ObjectId) -> [GoalSettings]  {
        var list:[GoalSettings] = []
        let allGoalSettingsObj = realm.objects(GoalSettings.self)
        let goalSettingFound = allGoalSettingsObj.where {
            $0.id == goalSettingId
        }
        
        for goalSetting in goalSettingFound {
            list.append(goalSetting)
        }
        return list
    }
    
    //Find Contact From Specific Search
    func findGoalSettings(searchText search:String,_ goalSettings:GoalSettings) -> Bool {
        var returnValue:Bool = false
        let searchWords = search.split(separator: " ")
        
        for word in searchWords {
            if  goalSettings.title.contains(word) {
                returnValue = true
            }
        }
        return returnValue
    }

    //Create a new GoalSettings
    func createNewGoalSettings(_ goalSetting:GoalSettings){
        
        let goalSettingObj = GoalSettings(
            title: goalSetting.title,
            project: goalSetting.project.count > 0 && projectsFunctionalityObj.findProjects(goalSetting.project[0].id).count  == 0 ?
            List<Projects>() : goalSetting.project,
            initialMetric: goalSetting.initialMetric,
            currentMetric: goalSetting.currentMetric,
            type: goalSetting.type,
            startDate: goalSetting.startDate,
            endDate: goalSetting.endDate,
            complete:goalSetting.complete
        )
        
        try! realm.write {
            realm.create(GoalSettings.self, value: goalSettingObj, update: .all)
       }
    }
    
    //Delete GoalSetting
    func deleteGoalSettings(_ goalSettingId:ObjectId){
        let allGoalSettingsObj = realm.objects(GoalSettings.self)
        let goalSettingDelete = allGoalSettingsObj.where {
            $0.id == goalSettingId
        }
        
        try! realm.write {
            realm.delete(goalSettingDelete)
        }
    }
    
    //Update current GoalSettings
    func saveGoalSettings(_ goalSetting:GoalSettings,_ goalSettingId:ObjectId) {
        let goalSettingObj = GoalSettings(
            title: goalSetting.title,
            project: goalSetting.project.count > 0 && projectsFunctionalityObj.findProjects(goalSetting.project[0].id).count  == 0 ?
            List<Projects>() : goalSetting.project,
            initialMetric: goalSetting.initialMetric,
            currentMetric: goalSetting.currentMetric,
            type: goalSetting.type,
            startDate: goalSetting.startDate,
            endDate: goalSetting.endDate,
            complete:goalSetting.complete
        )
        goalSettingObj.id = goalSettingId
 
        try! realm.write {
             realm.create(GoalSettings.self, value: goalSettingObj, update: .modified)
        }
    }
    
    func convertGoalSettingContactsArrayToList(_ array:[Contacts]) -> List<Contacts> {
         let list = List<Contacts>()
         list.append(objectsIn: array)
         return list
    }
    
    func convertGoalSettingContactsListToArray(_ list:List<Contacts>) -> [Contacts] {
         var array:[Contacts] = []
         array.append(contentsOf:list)
         return array
    }
    
    func changeDateFormat(date:Date) -> String {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
     }
}
