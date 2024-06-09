//
//  InsideDynamicFormListViewModel.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 19/6/23.
//

import Foundation
import RealmSwift

class InsideDynamicFormListViewModel: ObservableObject {
    @ObservedResults(DynamicForms.self) var allDynamicForms
    
    //MARK: Published Properties
    @Published var listCount:Int = 0
    @Published var showingAddNewFormSheet = false
    @Published var editExistedFormSheet = false
    @Published var dynamicFormID:ObjectId?
    @Published var searchText = ""
    @Published var shouldUpdateList = false
    @Published var navigationBarTitleName:String = ""
    @Published var addNewEntry = false
    
    //MARK: let Properties
    private let contactsFunctionality = ContactsFunctionality()
    let formId:ObjectId?
    
    //MARK: var Properties
    private var notificationToken:NotificationToken?
    var dynamicFormsFunctionality = DynamicFormsFunctionality()
    var dynamicFormsEntries: [DynamicFormsEntries] {
        if allDynamicForms.filter("id = %@ AND isEmpty = %@", formId!,false).count > 0 {
            return Array(allDynamicForms.filter("id = %@ AND isEmpty = %@", formId!,false)[0].entries.sorted(byKeyPath: "id", ascending: true))
        }else{
            return []
        }
        
    }
    
    var dynamicFormsFields: [DynamicFormsFields] {
        return Array(allDynamicForms.filter("id = %@",formId!)[0].entries[0].fields)
    }

    var filteredInsideDynamicFormEntries: [DynamicFormsEntries] {
        if searchText.isEmpty {
            return dynamicFormsEntries
        }
        else {
            return dynamicFormsEntries.filter { dynamicForm in
                dynamicFormsFunctionality.findDynamicFormsEntries(searchText: searchText, dynamicForm)
            }
        }
    }

    //MARK: Initialization
    init(formId:ObjectId?) {
        self.formId = formId
        notificationToken = RealmManager.shared.realm.observe { [weak self] (_ ,_)  in
            self?.objectWillChange.send()
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    //MARK: Functions
    func formName() -> String{
        return allDynamicForms.filter("id = %@", formId!,true)[0].name
    }
    
    func updateListId(){
        shouldUpdateList.toggle()
        listCount = dynamicFormsEntries.count
    }
    
    func formatDate(_ date: Date) -> String {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "dd/MM/yyyy" // Set the desired European date format
          return dateFormatter.string(from: date)
    }
 
    func contactsListToString(_ customContactOsbj: ContactsCustomObj) -> String {
        var array:[String] = []
        let list = customContactOsbj.contacts.map { "\($0.firstName) \($0.surnName)" }
        array.append(contentsOf:list)
        let contactsString = array.joined(separator: " ,")
        return contactsString
    }
    
    func tasksListToString(_ customTasksObj: TasksCustomObj) -> String {
        var array:[String] = []
        let list = customTasksObj.tasks.map { "\(!$0.code.isEmpty ? $0.code+", "+$0.title : $0.title)" }
        array.append(contentsOf:list)
        let tasksString = array.joined(separator: " ,")
        return tasksString
    }
    
    func projectsListToString(_ customProjectsObj: ProjectsCustomObj) -> String {
        var array:[String] = []
        let list = customProjectsObj.projects.map { "\(!$0.code.isEmpty ? $0.code+", "+$0.title : $0.title)" }
        array.append(contentsOf:list)
        let projectsString = array.joined(separator: " ,")
        return projectsString
    }
    
    func getItemText(for entry: DynamicFormsEntries) -> String {
        guard let fieldValue = entry.fields.first?.fieldValue?.fieldValue else {
            return "Press to edit"
        }
        switch entry.fields[0].type {
            case 1, 4, 8, 9:
                if case let .string(stringValue) = fieldValue {
                    return !stringValue.isEmpty ? stringValue : "Press to edit"
                }
            case 2:
                if case let .bool(booleanValue) = fieldValue {
                    return String(booleanValue)
                }
            case 3:
                if case let .int(intValue) = fieldValue {
                    return String(intValue)
                }
            case 5:
                if case let .date(dateValue) = fieldValue {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy" // Customize the date format as desired
                    return dateFormatter.string(from: dateValue)
                }
            case 6:
                if case let .object(contactsObject) = fieldValue, let contactsArray = contactsObject as? ContactsCustomObj {
                    return contactsArray.contacts.count > 0 ? contactsListToString(contactsArray) : "Press to edit"
                }
            case 7:
                if case let .object(tasksObject) = fieldValue, let tasksArray = tasksObject as? TasksCustomObj {
                    return tasksArray.tasks.count > 0 ? tasksListToString(tasksArray) : "Press to edit"
                }
            case 10:
                if case let .object(projectsObject) = fieldValue, let projectsArray = projectsObject as? ProjectsCustomObj {
                    return projectsArray.projects.count > 0 ? projectsListToString(projectsArray) : "Press to edit"
                }
            default:
                break
        }
        return "Press to edit"
    }
    
    func deleteDynamicForm(offsets: IndexSet) {
        let index = offsets[offsets.startIndex]
        let entryId = dynamicFormsEntries[index].id
        dynamicFormsFunctionality.deleteEntry(entryId,formId!)
        updateListId()
    }
}
