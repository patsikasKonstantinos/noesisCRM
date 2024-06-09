//
//  ProjectsFunctionality.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 2/10/22.
//

import Foundation
import RealmSwift
import Realm

class ProjectsFunctionality:ObservableObject{
    
    //MARK: Properties
    let realm = RealmManager.shared.realm
    let contactsFunctionalityObj = ContactsFunctionality()

    //MARK: Functions
    func convertCustomersArrayToList(_ array:[Contacts]) -> List<Contacts> {
         let list = List<Contacts>()
         list.append(objectsIn: array)
         return list
    }
    
    func convertProjectsArrayToList(_ array:[Projects]) -> List<Projects> {
        let list = List<Projects>()
        list.append(objectsIn: array)
        return list
    }
    
    func convertProjectListToArray(_ list:List<Projects>) -> [Projects] {
        var array:[Projects] = []
        array.append(contentsOf:list)
        return array
    }
    
    func convertCustomersListToArray(_ list:List<Contacts>) -> [Contacts] {
         var array:[Contacts] = []
         array.append(contentsOf:list)
         return array
    }

    func convertProjectTasksListToArray(_ list:List<Tasks>) -> [Tasks] {
         var array:[Tasks] = []
         array.append(contentsOf:list)
         return array
    }
    
    func convertProjectTasksArrayToList(_ array:[Tasks]) -> List<Tasks> {
         let list = List<Tasks>()
         list.append(objectsIn: array)
         return list
    }
    
    //Return Projects
    func findProjects() -> Results<Projects> {
        let projects = realm.objects(Projects.self).sorted(byKeyPath: "finsihDate", ascending: true)
        return projects
    }
    
    //Return Specific Projects
    func findProjects(_ searchText:String,_ initProjects:Results<Projects>) -> Results<Projects>  {
        let projectsSearch = initProjects.where {
            $0.title.contains(searchText) ||
            $0.code.contains(searchText)   
            
         }
         return projectsSearch
    }

    //Return Specific Project Id
    func findProjects(_ projectId:ObjectId) -> Results<Projects>  {
        let allProjectsObj = realm.objects(Projects.self)
        let projectFound = allProjectsObj.where {
            $0.id == projectId
        }
        return projectFound
    }
    
    func findProjects(searchText search:String,_ project:Projects) -> Bool {
        var returnValue:Bool = false
        let searchWords = search.split(separator: " ")
        
        for word in searchWords {
            if  project.title.contains(word) ||
                project.code.contains(word)
            {
                returnValue = true
            }
        }
        return returnValue
    }
    
    //Create a new Projects
    func createNewProjects(_ project:Projects){
        let projectObj = Projects(
            customers:project.customers.count > 0 && contactsFunctionalityObj.findContacts(project.customers[0].id).count  == 0 ?
            List<Contacts>() : project.customers,
            code: project.code,
            title: project.title,
            status: project.status,
            startDate: project.startDate,
            finishDate: project.finishDate,
            tasks:project.tasks

        )
        
        try! realm.write {
            realm.create(Projects.self, value: projectObj,update: .all)
        }
    }
    
    //Delete Project
    func deleteProjects(_ projectId:ObjectId){
        let allProjectsObj = realm.objects(Projects.self)
        let projectDelete = allProjectsObj.where {
            $0.id == projectId
        }
        
        try! realm.write {
            realm.delete(projectDelete)
        }
    }
    
    //Update current Projects
    func saveProjects(_ project:Projects,_ projectId:ObjectId) {
        let updatedObject = Projects(
            customers:project.customers.count > 0
            && contactsFunctionalityObj.findContacts(project.customers[0].id).count  == 0 ?
            List<Contacts>() : project.customers,
            code: project.code,
            title: project.title,
            status: project.status,
            startDate: project.startDate,
            finishDate: project.finishDate,
            tasks:project.tasks
        )
        updatedObject.id = projectId
        
        try! realm.write {
             realm.create(Projects.self, value: updatedObject, update: .modified)
        }
    }
}
