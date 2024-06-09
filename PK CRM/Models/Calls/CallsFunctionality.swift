//
//  CallsFunctionality.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 2/10/22.
//

import Foundation
import RealmSwift

class CallsFunctionality:ObservableObject{
    
    //MARK: Properties
    let realm = RealmManager.shared.realm
    let contactsFunctionalityObj = ContactsFunctionality()
    let projectssFunctionalityObj = ProjectsFunctionality()
    let dateFormatter = DateFormatter()

    //MARK: Functions
    func convertCallsArrayToList(_ array:[Calls]) -> List<Calls> {
         let list = List<Calls>()
         list.append(objectsIn: array)
         return list
    }
    
    //Return Calls
    func findCalls() -> Results<Calls> {
        let calls = realm.objects(Calls.self).sorted(byKeyPath: "firstName", ascending: true)
        return calls
    }
    
    //Return Specific Call Id
    func findCalls(_ callId:ObjectId) -> Results<Calls>  {
        let allCallsObj = realm.objects(Calls.self)
        let callFound = allCallsObj.where {
            $0.id == callId
        }
        return callFound
    }
    
    //Return Specific Call Id
    func findCallsArrayFormat(_ callId:ObjectId) -> [Calls]  {
        var list:[Calls] = []
        let allCallsObj = realm.objects(Calls.self)
        let callFound = allCallsObj.where {
            $0.id == callId
        }
        for call in callFound {
            list.append(call)
        }
        return list
    }
    
    //Find Contact From Specific Search
    func findCalls(searchText search:String,_ calls:Calls) -> Bool {
        var returnValue:Bool
        if calls.users.map({"\($0.firstName) \($0.surnName)"}).joined(separator: ",").contains(search) ||
        calls.customers.map({"\($0.firstName) \($0.surnName)"}).joined(separator: ",").contains(search){
            returnValue = true
        }else{
            returnValue = false
        }
        return returnValue
    }
    
    //Create a new Calls
    func createNewCalls(_ call:Calls){
        let callObj = Calls(
            users:call.users.count > 0 && contactsFunctionalityObj.findContacts(call.users[0].id).count  == 0 ?
            List<Contacts>() : call.users,
            customers:call.customers.count > 0 && contactsFunctionalityObj.findContacts(call.customers[0].id).count  == 0 ?
            List<Contacts>() : call.customers,
            date:call.date,
            comments:call.comments,
            duration:call.duration
        )
        
        try! realm.write {
            realm.create(Calls.self, value: callObj, update: .all)
        }
    }
    
    //Delete Call
    func deleteCalls(_ callId:ObjectId){
        let allCallsObj = realm.objects(Calls.self)
        let callDelete = allCallsObj.where {
            $0.id == callId
        }
        
        try! realm.write {
            realm.delete(callDelete)
        }
    }
    
    //Update current Calls
    func saveCalls(_ call:Calls,_ callId:ObjectId) {
        let callObj = Calls(
            users:call.users.count > 0 && contactsFunctionalityObj.findContacts(call.users[0].id).count  == 0 ?
            List<Contacts>() : call.users,
            customers:call.customers.count > 0 && contactsFunctionalityObj.findContacts(call.customers[0].id).count  == 0 ?
            List<Contacts>() : call.customers,
            date:call.date,
            comments:call.comments,
            duration:call.duration
        )
        callObj.id = callId
        
        try! realm.write {
             realm.create(Calls.self, value: callObj, update: .modified)
        }
    }
    
    func convertCallContactsArrayToList(_ array:[Contacts]) -> List<Contacts> {
         let list = List<Contacts>()
         list.append(objectsIn: array)
         return list
    }
    
    func convertCallContactsListToArray(_ list:List<Contacts>) -> [Contacts] {
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
