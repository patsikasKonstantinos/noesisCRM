//
//  TaskViewModel.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 18/6/23.
//

import Foundation

import RealmSwift
import Combine

class TaskViewModel: ObservableObject {
    
    //MARK: Published Properties
    @Published var filledCode = true
    @Published var filledTitle = true
    @Published var date:Date = Date()
    @Published var alertMessage = ""
    @Published var tasksObj:Tasks?
    @Published var tasksList:[Tasks] = []
    @Published var statusSelection:Int = 0
    @Published var inputTextList: [Int:String] = [:]
    @Published var inputTextStringsController: [String] = ["","","0","","","",""]
    @Published var appear:Bool = false
    @Published var showingAlert = false
    @Published var title: String = ""
    @Published var comments: String = ""
    @Published var code: String = ""
    @Published var startDate: Date = Date()
    @Published var finishDate: Date = Date()
    @Published var status: Int = 0
    @Published var selectedContacts:[Contacts] = []
    @Published var fromNavigation = false
    
    //MARK: let Properties
    private let dismissView = PassthroughSubject<Void, Never>()
    private let tasksFunctionalityObj = TasksFunctionality()
    let listViewItems =  Variables.taskViewListItems
    let projectStatus =  Variables.projectStatus
    
    //MARK: var Properties
    var newTask:Bool
    var selectedTaskIndex:Int?
    var dismissRequest: AnyPublisher<Void, Never> {
         dismissView.eraseToAnyPublisher()
    }
     
    lazy var selectContactsViewModel: SelectContactsViewModel = {
           return SelectContactsViewModel(multiple: true, contactType: 3,selected: selectedContacts)
    }()
 
    //MARK: Initialization
    init(newTask: Bool,selectedTaskIndex:Int?) {
        self.newTask = newTask
        self.selectedTaskIndex = selectedTaskIndex
    }
   
    //MARK: Functions
    func saveTasks(completion:@escaping(Bool)->Void){
    
        if inputTextStringsController[1].isEmpty{
            filledTitle = false
        }

        if !inputTextStringsController[1].isEmpty &&
            finishDate >= startDate {
            tasksObj = Tasks(
                code: inputTextStringsController[0],
                title: inputTextStringsController[1],
                status: statusSelection,
                startDate: startDate,
                finishDate: finishDate,
                comments: inputTextStringsController[6],
                assignments: tasksFunctionalityObj.convertAssignmentsArrayToList(selectContactsViewModel.selected)
            )
            if let taskIndex = selectedTaskIndex {
                tasksList[taskIndex] = tasksObj!
            }
            else{
                tasksList.append(tasksObj!)
            }
            selectedTaskIndex = nil
            completion(true)
            dismissView.send()
        }
        else{
            if  inputTextStringsController[1].isEmpty {
                alertMessage = "Please fill out all required fields"
            }
            else{
                alertMessage = "Τhe start date must be before the finish date"
            }
            showingAlert = true
            completion(false)
        }
    }
    
    func setup(_ task:[Tasks]){
        if(!newTask){
            code = task[selectedTaskIndex!].code
            title = task[selectedTaskIndex!].title
            statusSelection = task[selectedTaskIndex!].status
            startDate = task[selectedTaskIndex!].startDate
            finishDate = task[selectedTaskIndex!].finishDate
            comments = task[selectedTaskIndex!].comments
            selectedContacts = tasksFunctionalityObj.convertAssignmentsListToArray(task[selectedTaskIndex!].assignments)
            selectContactsViewModel.selected = selectedContacts

            inputTextStringsController=[code,title,"\(status)","\(startDate)","\(finishDate)","","\(comments)"]
        }
        
        DispatchQueue.main.async {
            self.tasksList = task
        }
    }
}
