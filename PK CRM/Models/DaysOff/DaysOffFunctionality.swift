//
//  DaysOffFunctionality.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 2/10/22.
//

import Foundation
import RealmSwift

class DaysOffFunctionality:ObservableObject{
    
    //MARK: Properties
    let realm = RealmManager.shared.realm
    let contactsFunctionalityObj = ContactsFunctionality()
    let projectssFunctionalityObj = ProjectsFunctionality()
    let dateFormatter = DateFormatter()
    
    //MARK: Functions
    func convertContactsListToArray(_ list:List<Contacts>) -> [Contacts] {
        var array:[Contacts] = []
        array.append(contentsOf:list)
        return array
    }
    
    func convertContactsArrayToList(_ array:[Contacts]) -> List<Contacts> {
         let list = List<Contacts>()
         list.append(objectsIn: array)
         return list
    }
    
    func convertDaysOffArrayToList(_ array:[DaysOff]) -> List<DaysOff> {
         let list = List<DaysOff>()
         list.append(objectsIn: array)
         return list
    }
    
    //Return DaysOff
    func findDaysOff() -> Results<DaysOff> {
        let daysOffs = realm.objects(DaysOff.self).sorted(byKeyPath: "firstName", ascending: true)
        return daysOffs
    }

    //Return Specific DaysOff Id
    func findDaysOff(_ date:Date) -> Results<DaysOff>  {
        let allDaysOffObj = realm.objects(DaysOff.self)

        let daysOffFound = allDaysOffObj.where {
            $0.date == date
        }
        return daysOffFound
    }
    
    //Return Specific DaysOff Id
    func findDaysOffArrayFormat(_ daysOffId:ObjectId) -> [DaysOff]  {
        
        var list:[DaysOff] = []
        let allDaysOffObj = realm.objects(DaysOff.self)
        let daysOffFound = allDaysOffObj.where {
            $0.id == daysOffId
        }
        for daysOff in daysOffFound {
            list.append(daysOff)

        }
        return list
    }
    
    //Find Contact From Specific Search
    func findDaysOff(searchText search:String,_ daysOffs:DaysOff) -> Bool {
        return true
    }
    
    func daysOffUsersFromSpecificDate(_ date:Date) -> String {
        var daysOffUsers:String = ""
        let daysOff = findDaysOff(date)
        if daysOff.count > 0 {
            let users = daysOff[0].users
            for user in users{
                daysOffUsers = daysOffUsers + "\n" + user.firstName + user.surnName
            }
        }
        return daysOffUsers
    }
 
    func existDaysOffUserFromSpecificDate(_ date:Date) -> Bool {
        let daysOff = findDaysOff(date)
        if daysOff.count > 0 {
            let users = daysOff[0].users
            if users.count > 0 {
                return true
            }
            else{
                return false
            }
        }else{
            return false
        }
     }
    
    //Create a new DaysOff
    func createNewDaysOff(_ daysOff:DaysOff){
        let daysOffObj = DaysOff(
            users:daysOff.users.count > 0 && contactsFunctionalityObj.findContacts(daysOff.users[0].id).count  == 0 ?
            List<Contacts>() : daysOff.users,
            date:daysOff.date,
            comments:daysOff.comments
        )
        try! realm.write {
            realm.create(DaysOff.self, value: daysOffObj, update: .all)
       }
    }
    
    //Delete DaysOff
    func deleteDaysOff(_ daysOffId:ObjectId){
        let allDaysOffObj = realm.objects(DaysOff.self)

        let daysOffDelete = allDaysOffObj.where {
            $0.id == daysOffId
        }
        try! realm.write {
            realm.delete(daysOffDelete)
        }
    }
    
    //Update current DaysOff
    func saveDaysOff(_ daysOff:DaysOff) {
        let daysOffFound = findDaysOff(daysOff.date)
        let daysOffObj = DaysOff(
            users:daysOff.users.count > 0 && contactsFunctionalityObj.findContacts(daysOff.users[0].id).count  == 0 ?
            List<Contacts>() : daysOff.users,
            date:daysOff.date,
            comments:daysOff.comments
        )
        if !daysOffFound.isEmpty {
            daysOffObj.id = daysOffFound[0].id
        }
        try! realm.write {
             realm.create(DaysOff.self, value: daysOffObj, update: .modified)
        }
    }
    
    func convertDaysOffContactsArrayToList(_ array:[Contacts]) -> List<Contacts> {
         let list = List<Contacts>()
         list.append(objectsIn: array)
         return list
    }
    
    func convertDaysOffContactsListToArray(_ list:List<Contacts>) -> [Contacts] {
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
