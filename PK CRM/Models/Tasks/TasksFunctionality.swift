//
//  ProjectsFunctionality.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 2/10/22.
//

import Foundation
import RealmSwift
import Realm

class TasksFunctionality:ObservableObject{
    
    //MARK: Properties
    let realm = RealmManager.shared.realm
    let projectssFunctionalityObj = ProjectsFunctionality()

    //MARK: Functions
    func convertTasksListToArray(_ list:List<Tasks>) -> [Tasks] {
         var array:[Tasks] = []
         array.append(contentsOf:list)
         return array
    }
    
    //Return Specific Tasks
    //Find Project From Specific Sercg
    func findTasks(searchText search:String,_ task:Tasks) -> Bool {
        var returnValue:Bool = false
        let searchWords = search.split(separator: " ")
        for word in searchWords {
            if  task.title.contains(word) {
                returnValue = true
            }
        }
        return returnValue
    }

    func convertAssignmentsArrayToList(_ array:[Contacts]) -> List<Contacts> {
         let list = List<Contacts>()
         list.append(objectsIn: array)
         return list
    }
    
    func convertAssignmentsListToArray(_ list:List<Contacts>) -> [Contacts] {
         var array:[Contacts] = []
         array.append(contentsOf:list)
         return array
    }
}
