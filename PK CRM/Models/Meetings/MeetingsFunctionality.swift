//
//  MeetingsFunctionality.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 2/10/22.
//

import Foundation
import RealmSwift

class MeetingsFunctionality:ObservableObject{
    
    //MARK: Properties
    let realm = RealmManager.shared.realm
    let contactsFunctionalityObj = ContactsFunctionality()
    let projectssFunctionalityObj = ProjectsFunctionality()
    let dateFormatter = DateFormatter()

    //MARK: Functions
    func convertMeetingsArrayToList(_ array:[Meetings]) -> List<Meetings> {
         let list = List<Meetings>()
         list.append(objectsIn: array)
         return list
    }
    
    //Return Meetings
    func findMeetings() -> Results<Meetings> {
        let meetings = realm.objects(Meetings.self).sorted(byKeyPath: "firstName", ascending: true)
        return meetings
    }

    //Return Specific Meeting Id
    func findMeetings(_ meetingId:ObjectId) -> Results<Meetings>  {
        let allMeetingsObj = realm.objects(Meetings.self)

        let meetingFound = allMeetingsObj.where {
            $0.id == meetingId
        }
        return meetingFound
    }
    
    //Return Specific Meeting Id
    func findMeetingsArrayFormat(_ meetingId:ObjectId) -> [Meetings]  {
        var list:[Meetings] = []
        let allMeetingsObj = realm.objects(Meetings.self)

        let meetingFound = allMeetingsObj.where {
            $0.id == meetingId
        }
        for meeting in meetingFound {
            list.append(meeting)

        }
        return list
    }
    
    //Find Contact From Specific Search
    func findMeetings(searchText search:String,_ meetings:Meetings) -> Bool {
        var returnValue:Bool = false
        let searchWords = search.split(separator: " ")
        for word in searchWords {
            if  meetings.title.contains(word) {
                returnValue = true
            }
        }
        return returnValue
    }

    //Create a new Meetings
    func createNewMeetings(_ meeting:Meetings){
        let meetingObj = Meetings(
            title:meeting.title,
            customers:meeting.customers.count > 0 && contactsFunctionalityObj.findContacts(meeting.customers[0].id).count  == 0 ?
            List<Contacts>() : meeting.customers,
            date:meeting.date,
            comments:meeting.comments,
            completed:meeting.completed
        )
        try! realm.write {
            realm.create(Meetings.self, value: meetingObj, update: .all)
       }
    }
    
    //Delete Meeting
    func deleteMeetings(_ meetingId:ObjectId){
        
        let allMeetingsObj = realm.objects(Meetings.self)

        let meetingDelete = allMeetingsObj.where {
            $0.id == meetingId
        }
        try! realm.write {
            realm.delete(meetingDelete)
        }
    }
    
    //Update current Meetings
    func saveMeetings(_ meeting:Meetings,_ meetingId:ObjectId) {
         let meetingObj = Meetings(
            title:meeting.title,
            customers:meeting.customers.count > 0 && contactsFunctionalityObj.findContacts(meeting.customers[0].id).count  == 0 ?
            List<Contacts>() : meeting.customers,
            date:meeting.date,
            comments:meeting.comments,
            completed:meeting.completed
        )
        meetingObj.id = meetingId
        try! realm.write {
             realm.create(Meetings.self, value: meetingObj, update: .modified)
        }
    }
    
    func convertMeetingContactsArrayToList(_ array:[Contacts]) -> List<Contacts> {
         let list = List<Contacts>()
         list.append(objectsIn: array)
         return list
    }
    
    func convertMeetingContactsListToArray(_ list:List<Contacts>) -> [Contacts] {
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
