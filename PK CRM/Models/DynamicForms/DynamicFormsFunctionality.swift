//
//  DynamicFormsFunctionality.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 22/4/23.
//

import Foundation
import RealmSwift
import Realm

class DynamicFormsFunctionality{
    
    //MARK: Properties
    let realm = RealmManager.shared.realm
    let contactsFunctionalityObj = ContactsFunctionality()
    let projectssFunctionalityObj = ProjectsFunctionality()
    var dynamicFormsFields:[DynamicFormsFields] = []

    //MARK: Functions
    func convertFieldsListToArray(_ list:List<DynamicFormsFields>) -> [DynamicFormsFields] {
         var array:[DynamicFormsFields] = []
         array.append(contentsOf:list)
         return array
    }
    
    func convertFieldsArrayToList(_ array:[DynamicFormsFields]) -> List<DynamicFormsFields> {
         let list = List<DynamicFormsFields>()
         list.append(objectsIn: array)
         return list
    }
    
    func convertEntriesListToArray(_ list:List<DynamicFormsEntries>) -> [DynamicFormsEntries]{
         var array:[DynamicFormsEntries] = []
         array.append(contentsOf:list)
         return array
    }

    func convertEntriesArrayToList(_ array:[DynamicFormsEntries]) -> List<DynamicFormsEntries> {
         let list = List<DynamicFormsEntries>()
         list.append(objectsIn: array)
         return list
    }
    
    //Find Form From Specific Search
    func findDynamicForms(searchText search:String,_ dynamicForms:DynamicForms) -> Bool {
        var returnValue:Bool = false
        let searchWords = search.split(separator: " ")
        
        for word in searchWords {
            if  dynamicForms.name.contains(word){
                returnValue = true
            }
        }
        return returnValue
    }
    
    func findDynamicFormsEntries(searchText search:String,_ entries:DynamicFormsEntries) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy" // Set the desired European date forma
        var returnValue:Bool = false;
        
        if  entries.fields[0].type == 1 ||
            entries.fields[0].type == 4 ||
            entries.fields[0].type == 8 ||
            entries.fields[0].type == 9 {
            if case let .string(stringValue) = entries.fields[0].fieldValue?.fieldValue {
                if(stringValue.contains(search)){
                    returnValue = true
                }
            }
        }
        else if entries.fields[0].type == 2 {
             if case let .bool(booleanValue) = entries.fields[0].fieldValue?.fieldValue {
                 if(String(booleanValue).contains(search)){
                     returnValue = true
                 }
             }
        }
        else if entries.fields[0].type == 3 {
            if case let .int(intValue) = entries.fields[0].fieldValue?.fieldValue {
                if(String(intValue).contains(search)){
                    returnValue = true
                }
            }
        }
        else if entries.fields[0].type == 5 {
            if case let .date(dateValue) = entries.fields[0].fieldValue?.fieldValue {                
                if(String( dateFormatter.string(from: dateValue)).contains(search)){
                    returnValue = true
                }
            }
        }
        else if entries.fields[0].type == 6 {
            if let anyValue = entries.fields[0].fieldValue?.fieldValue {
                if case let .object(contactsObject) = anyValue, let contactsArray = contactsObject  as? ContactsCustomObj {
                    if  contactsArray.contacts.map {"\($0.firstName) \($0.surnName)"}.joined(separator: ",").contains(search){
                        returnValue = true
                    }
                 }
            }
        }
        else if entries.fields[0].type == 7 {
            if let anyValue = entries.fields[0].fieldValue?.fieldValue {
                if case let .object(tasksObject) = anyValue, let tasksArray = tasksObject  as? TasksCustomObj {
                    if  tasksArray.tasks.map {"\(!$0.code.isEmpty ? $0.code+" "+$0.title : $0.title)"}.joined(separator: ",").contains(search) || tasksArray.tasks.map {"\(!$0.code.isEmpty ? $0.code+", "+$0.title : $0.title)"}.joined(separator: ",").contains(search){
                        returnValue = true
                    }
                 }
            }
        }
        else if entries.fields[0].type == 10 {
            if let anyValue = entries.fields[0].fieldValue?.fieldValue {
                if case let .object(projectsObject) = anyValue, let projectsArray = projectsObject  as? ProjectsCustomObj {
                    if  projectsArray.projects.map {"\($0.code) \($0.title)"}.joined(separator: ",").contains(search){
                        returnValue = true
                    }
                 }
            }
        }
        else{
            returnValue = false
        }
        return returnValue
    }
    
    //Delete Form
    func deleteDynamicForms(_ formId:ObjectId){
        let allFormsObj = realm.objects(DynamicForms.self)
        let formDelete = allFormsObj.where {
            $0.id == formId
        }
        try! realm.write {
            realm.delete(formDelete)
        }
    }
    
    func deleteEntry(_ entryId:ObjectId,_ formId:ObjectId){
        let allFormsObj = realm.objects(DynamicForms.self)
        let entryObj = realm.objects(DynamicFormsEntries.self).filter("id = %@", entryId)
        let form = allFormsObj.where {
            $0.id == formId
        }
        if(form[0].entries.count>1){
             let entryDelete = entryObj.where {
                $0.id == entryId
            }
            try! realm.write {
                realm.delete(entryDelete)
            }
        }
        else{
            
            for field in form[0].entries[0].fields {
                let fieldId = field.id
                let dynamicFieldsObj = DynamicFormsFieldsValue(fieldValue:.none)
                let updatedObject = DynamicFormsFields(name: field.name, type: field.type, required: field.required, position:  field.position)
                updatedObject.id = fieldId

                //UPDATE ALL FIELDS
                try! realm.write {
                    realm.create(DynamicFormsFields.self, value: updatedObject, update: .modified)
                }
            }
            
            //SET NEW ENTRY FLAG
            let formNew = allFormsObj.where {
                $0.id == formId
            }
            let dynamicFormsObj = DynamicForms(name: form[0].name, isEmpty: true, entries: formNew[0].entries)
            dynamicFormsObj.id = formId
            try! realm.write {
                realm.create(DynamicForms.self, value: dynamicFormsObj, update: .modified)
            }
        }
    }
    
    func newEntry(_ controller:[Any],_ formId:ObjectId,_ forminations:[DynamicFormsFields],
                  _ newEntry:Bool,_ entryId:ObjectId?){
        var newDynamicFormEntry = DynamicFormsEntries()
        var contactsDictionary: [Int: List<Contacts>] = [:]
        var tasksDictionary: [Int: List<Tasks>] = [:]
        var projectsDictionary: [Int: List<Projects>] = [:]
 
        for (index, formination) in forminations.enumerated() {
            let dynamicFieldsObj = DynamicFormsFields(
                name: formination.name,
                type: formination.type ,
                required: formination.required ,
                position:index
            )
            if  formination.type == 1 ||
                formination.type == 4 ||
                formination.type == 8 ||
                formination.type == 9 {
                if let controllerString = controller[index] as? String {
                    dynamicFieldsObj.fieldValue = DynamicFormsFieldsValue(
                        fieldValue:AnyRealmValue.string(controllerString)
                    )
                }
            }
            else if formination.type == 2 {
                if let controllerString = controller[index] as? Bool {
                    dynamicFieldsObj.fieldValue = DynamicFormsFieldsValue(
                        fieldValue:AnyRealmValue.bool(controllerString)
                    )
                }
            }
            else if formination.type == 3 {
                if let controllerInt = controller[index] as? Int {
                    dynamicFieldsObj.fieldValue = DynamicFormsFieldsValue(
                        fieldValue:AnyRealmValue.int(controllerInt)
                    )
                }
            }
            else if formination.type == 5 {
                if let controllerDate = controller[index] as? Date {
                    dynamicFieldsObj.fieldValue = DynamicFormsFieldsValue(
                        fieldValue:AnyRealmValue.date(controllerDate)
                    )
                }
            }
            else if formination.type == 6 {
                var contactsList = List<Contacts>()
                if let controllerContacts = controller[index] as? [Contacts] {
                    for contact in controllerContacts {
                        let contactObj = Contacts(
                            type: contact.type,
                            firstName: contact.firstName,
                            surnName: contact.surnName,
                            telephoneNumber:contact.telephoneNumber,
                            mobilePhoneNumber: contact.mobilePhoneNumber,
                            country: contact.country,
                            state: contact.state,
                            city: contact.city,
                            address: contact.address,
                            postCode: contact.postCode,
                            taxId:  contact.taxId,
                            identityId: contact.identityId,
                            active:  contact.active
                        )
                        contactObj.id = contact.id
                        contactsList.append(contactObj)
                    }
                    contactsDictionary[index] = contactsList
                }
            }
            else if formination.type == 7 {
                var tasksList  = List<Tasks>()
                if let controllerTasks = controller[index] as? [Tasks] {
                     for task in controllerTasks {
                        let taskObj = Tasks(
                            code: task.code,
                            title: task.title,
                            status: task.status,
                            startDate: task.startDate,
                            finishDate: task.finishDate,
                            comments: task.comments,
                            assignments: task.assignments
                        )
                         taskObj.id = task.id
                         tasksList .append(taskObj)
                    }
                    tasksDictionary[index] = tasksList
                }
            }
            else if formination.type == 10 {
                var projectsList  = List<Projects>()
                if let controllerProjects = controller[index] as? [Projects] {
                     for project in controllerProjects {
                        let projectObj = Projects(
                            customers: project.customers,
                            code: project.code,
                            title: project.title,
                            status: project.status,
                            startDate: project.startDate,
                            finishDate: project.finishDate,
                            tasks: project.tasks
                        )
                        projectObj.id = project.id
                        projectsList .append(projectObj)
                    }
                    projectsDictionary[index] = projectsList
                }
            }

            //Contacts and Tasks
            if formination.type == 6 {
                let contactsArrObj = ContactsCustomObj(contacts: contactsDictionary[index] ?? List<Contacts>())
                if contactsArrObj.contacts.count > 0 {
                    if(contactsFunctionalityObj.findContacts(contactsArrObj.contacts[0].id).count)  == 0 {
                        contactsArrObj.contacts = List<Contacts>()
                    }
                }
                else {
                    contactsArrObj.contacts = List<Contacts>()
                }
                dynamicFieldsObj.fieldValue = DynamicFormsFieldsValue(
                     fieldValue:AnyRealmValue.object(contactsArrObj))
            }
            else if formination.type == 7 {
                let tasksArrObj = TasksCustomObj(tasks:tasksDictionary[index] ?? List<Tasks>())
                dynamicFieldsObj.fieldValue = DynamicFormsFieldsValue(
                     fieldValue:AnyRealmValue.object(tasksArrObj)
                )
            }
            else if formination.type == 10 {
                let projectsArrObj = ProjectsCustomObj(projects:projectsDictionary[index] ?? List<Projects>())
                dynamicFieldsObj.fieldValue = DynamicFormsFieldsValue(
                     fieldValue:AnyRealmValue.object(projectsArrObj)
                )
            }
            newDynamicFormEntry.fields.append(dynamicFieldsObj)
        }
        let allDynamicForms = realm.objects(DynamicForms.self)
        let findDynamicFormObj = allDynamicForms.where {$0.id == formId}
        let newDynamicFormObj = DynamicForms()
        newDynamicFormObj.id = formId
        newDynamicFormObj.name = findDynamicFormObj[0].name
        newDynamicFormObj.isEmpty = false
        
        if !newEntry {
            //DELETE OLD
            deleteEntry(entryId!,formId)
        }
        if !findDynamicFormObj[0].isEmpty {
            newDynamicFormObj.entries.append(objectsIn: findDynamicFormObj[0].entries)
        }
        if !newEntry {
            newDynamicFormEntry.id = entryId!
        }
        newDynamicFormObj.entries.append(newDynamicFormEntry)
        
        try! realm.write {
            realm.create(DynamicForms.self, value: newDynamicFormObj,update: .all)
        }
    }
     
    func createNewCustomForm(_ collectionName:String,_ fieldsController:(name:[String],type:[Int],required:[Bool],removed:[Bool]),completion:  (Bool) -> ()){
 
        for index in 0..<fieldsController.name.count {
            //If is not remove
            if !fieldsController.removed[index] {
                let dynamicFieldsObj = DynamicFormsFields(
                    name:  fieldsController.name[index],
                    type:  fieldsController.type[index] ,
                    required: fieldsController.required[index] ,
                    position:index
                )
                dynamicFormsFields.append(
                    dynamicFieldsObj
                )
            }
        }
        
        let dynamicFormsObj = DynamicForms(
            name: collectionName,
            isEmpty: true,
            entries: convertEntriesArrayToList([
                    DynamicFormsEntries(
                        fields:  convertFieldsArrayToList(
                            dynamicFormsFields
                        )
                    )
                ]
            )
        )
        
        do {
           try realm.write {
               realm.create(DynamicForms.self, value: dynamicFormsObj, update: .all)
               completion(true)
           }
       } catch {
           completion(false)
       }
    }
}
