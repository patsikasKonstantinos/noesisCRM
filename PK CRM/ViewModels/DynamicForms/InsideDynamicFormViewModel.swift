//
//  InsideDynamicFormViewModel.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 20/6/23.
//

import Foundation
import RealmSwift
import Combine

class InsideDynamicFormViewModel: ObservableObject {
    
    //MARK: Published Properties
    @Published var fromNavigation:Bool = false
    @Published var inputController: [Any] = []
    @Published var forminationObj = DynamicFormsFunctionality()
    @Published var contactsObj = ContactsFunctionality()
    @Published var tasksObj = TasksFunctionality()
    @Published var projectsObj = ProjectsFunctionality()
    @Published var entryId:ObjectId?
    @Published var alertView:Bool = false
    @Published var openTasks:Bool = false
    @Published var requiredFieldsText:String = ""
    @Published var checkedRequiredFields:Bool = false
    @Published var numOfRequiredFields:Int = 0
    @Published var selected:[Contacts] = []
    @Published var selectedContacts:[Int:[Contacts]] = [:]
    @Published var selectedProjects:[Int:[Projects]] = [:]
    @Published var selectedTasks:[Int:[Tasks]] = [:]
    
    //MARK: let Properties
    private let dismissView = PassthroughSubject<Void, Never>()
    let tasksListViewModel: TasksListViewModel = {
           return TasksListViewModel()
    }()
    let formId:ObjectId
    let formination:[DynamicFormsFields]
    let newEntry:Bool
    let country = Counries.countries
    
    //MARK: var Properties
    private var firstLoad: Bool = true
    var dismissRequest: AnyPublisher<Void, Never> {
        dismissView.eraseToAnyPublisher()
    }
    lazy var selectContactsViewModel: SelectContactsViewModelDynamic = {
           return SelectContactsViewModelDynamic(multiple: true, contactType: 3, selected: selected, navigationView: fromNavigation)
    }()
    
    lazy var selectProjectsViewModel: SelectProjectsViewModelDynamic = {
           return SelectProjectsViewModelDynamic(multiple: true)
    }()
     
    lazy var selectTasksViewModel: SelectTasksViewModelDynamic = {
           return SelectTasksViewModelDynamic()
    }()
    
    //MARK: Initialization
    init(formId:ObjectId,formination:[DynamicFormsFields],newEntry:Bool,entryId:ObjectId?) {
        self.formId = formId
        self.formination = formination
        self.newEntry = newEntry
        self.entryId = entryId
    }
 
    //MARK: Functions
    func saveEntry(){
        //SAVE ENTRY
        if newEntry {
            forminationObj.newEntry(inputController, formId,formination,newEntry,nil)
        }
        else{
            forminationObj.newEntry(inputController, formId,formination,newEntry,entryId!)
        }
        dismissView.send()
    }
    
    func checkRequiredFields(){
        var requiredFields = false
        var tempRequiredFieldsText:String = ""
        for index in 0..<formination.count {
            //if is required field
            if formination[index].required {
                numOfRequiredFields += 1
                if inputController.indices.contains(index){
                    if formination[index].type == 1 ||
                        formination[index].type == 4 ||
                        formination[index].type == 8 ||
                        formination[index].type == 9 {
                        if let stringValue = inputController[index] as? String {
                            if stringValue.isEmpty{
                                tempRequiredFieldsText = tempRequiredFieldsText + "\n" + "\(formination[index].name) Field is Required"
                                requiredFields = true
                             }
                        }
                    }
                    else if formination[index].type == 6 {
                        if let contactsArr = inputController[index] as? [Contacts] {
                            if contactsArr.isEmpty{
                                tempRequiredFieldsText = tempRequiredFieldsText + "\n" + "\(formination[index].name) Field is Required"
                                requiredFields = true
                            }
                        }
                    }
                    else if formination[index].type == 7 {
                        if let tasksArr = inputController[index] as? [Tasks] {
                            if tasksArr.isEmpty{
                                tempRequiredFieldsText = tempRequiredFieldsText + "\n" + "\(formination[index].name) Field is Required"
                                requiredFields = true
                            }
                        }
                    }
                    else if formination[index].type == 10 {
                        if let projectsArr = inputController[index] as? [Projects] {
                            if projectsArr.isEmpty{
                                tempRequiredFieldsText = tempRequiredFieldsText + "\n" + "\(formination[index].name) Field is Required"
                                requiredFields = true
                            }
                        }
                    }
                }
            }
        }
        if !requiredFields {
            saveEntry()
        }
        requiredFieldsText = tempRequiredFieldsText
        alertView = requiredFields
    }
    
    func resetForm(){
        if newEntry {
            alertView = false
            selectedContacts = [:]
            selectedTasks = [:]
            selectedProjects = [:]
            inputController = []
            setup()
        }
    }
    
    func setup(){
        if newEntry {
            for index in 0..<formination.count {
                if formination[index].type == 1 ||
                    formination[index].type == 4 ||
                    formination[index].type == 8 ||
                    formination[index].type == 9 {
                    inputController.append("")
                }
                else if formination[index].type == 2 {
                    inputController.append(false)
                }
                else if formination[index].type == 3 {
                    inputController.append(0)
                }
                else if formination[index].type == 5 {
                    inputController.append(Date())
                }
                else if formination[index].type == 6
                || formination[index].type == 7
                || formination[index].type == 10
                {
                    inputController.append([])
                }
            }
        }
        else{
            for index in 0..<formination.count {
                if formination[index].type == 1 ||
                    formination[index].type == 4 ||
                    formination[index].type == 8 ||
                    formination[index].type == 9 {
                    if case let .string(stringValue) = formination[index].fieldValue?.fieldValue {
                        let stringValue = stringValue
                        inputController.append(stringValue)
                    }
                }
                else if formination[index].type == 2 {
                    if case let .bool(intValue) = formination[index].fieldValue?.fieldValue {
                        let intValue = intValue
                        inputController.append(intValue)
                    }
                }
                else if formination[index].type == 3 {
                    if case let .int(intValue) = formination[index].fieldValue?.fieldValue {
                        let intValue = intValue
                        inputController.append(intValue)
                    }
                }
                else if formination[index].type == 5 {
                    if case let .date(dateValue) = formination[index].fieldValue?.fieldValue {
                        let dateValue = dateValue
                        inputController.append(dateValue)
                    }
                }
                else if formination[index].type == 6 {
                    if let anyValue = formination[index].fieldValue?.fieldValue {
                         if case let .object(contactsObject) = anyValue, let contactsArray = contactsObject  as? ContactsCustomObj {
                             // Use the `contactsArray` as an array of `Contacts`
                            inputController.append(contactsObj.convertContactsListToArray(contactsArray.contacts))
                            selectedContacts[index] = contactsObj.convertContactsListToArray(contactsArray.contacts)
                        }
                        else {
                            // Handle the case when the value is not an array of `Contacts`
                        }
                    }
                    else {
                        // Handle the case when the value is nil
                    }
                }
                else if formination[index].type == 7 {
                    if let anyValue = formination[index].fieldValue?.fieldValue {
                        if case let .object(tasksObject) = anyValue, let tasksArray = tasksObject  as? TasksCustomObj {
                             // Use the `contactsArray` as an array of `Contacts`
                            inputController.append(tasksObj.convertTasksListToArray(tasksArray.tasks))
                            selectedTasks[index] = tasksObj.convertTasksListToArray(tasksArray.tasks)

                         }
                        else {
                            // Handle the case when the value is not an array of `Contacts`
                        }
                    }
                    else {
                        // Handle the case when the value is nil
                    }
                }
                else if formination[index].type == 10 {
                    if let anyValue = formination[index].fieldValue?.fieldValue {
                        if case let .object(projectsObject) = anyValue, let projectsArray = projectsObject  as? ProjectsCustomObj {
                             // Use the `contactsArray` as an array of `Contacts`
                            inputController.append(projectsObj.convertProjectListToArray(projectsArray.projects))
                            selectedProjects[index] = projectsObj.convertProjectListToArray(projectsArray.projects)

                          }
                        else {
                            // Handle the case when the value is not an array of `Contacts`
                        }
                    }
                    else {
                        // Handle the case when the value is nil
                    }
                }
            }
        }
    }
}
