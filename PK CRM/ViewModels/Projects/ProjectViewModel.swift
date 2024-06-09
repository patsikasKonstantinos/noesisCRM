//
//  ProjectViewModel.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 13/6/23.
//

import Foundation
import RealmSwift
import Combine

class ProjectViewModel: ObservableObject {
    @ObservedResults(Projects.self) var allProjects
    
    //MARK: Published Properties
    @Published var project: Results<Projects>?
    @Published var projectTasks: [Tasks] = []
    @Published var code: String = ""
    @Published var title: String = ""
    @Published var startDate: Date = Date()
    @Published var finishDate: Date = Date()
    @Published var statusSelection: Int = 0
    @Published var status: Int = 0
    @Published var appear:Bool = false
    @Published var showingAlert = false
    @Published var filledCode: Bool = true
    @Published var filledTitle: Bool = true
    @Published var showAlert: Bool = false
    @Published var showDeleteAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var listViewItems = Variables.projectViewListItems
    @Published var fromNavigation = false
    @Published var selectedCustomers: [Contacts] = []
    @Published var inputTextList: [Int:String] = [:]
    @Published var inputTextStringsController: [String] = ["","","0","",""]
    
    //MARK: let Properties
    private let projectsObj = ProjectsFunctionality()
    private let dismissView = PassthroughSubject<Void, Never>()
    let projectStatus =  Variables.projectStatus
    
    //MARK: var Properties
    private var firstLoad: Bool = true
    var newProject: Bool
    var projectId: ObjectId?
 
    var dismissRequest: AnyPublisher<Void, Never> {
         dismissView.eraseToAnyPublisher()
    }
    
    lazy var selectContactsViewModel: SelectContactsViewModel = {
           return SelectContactsViewModel(multiple: true, contactType: 3,selected: selectedCustomers)
    }()
    
    //MARK: Initialization
    init(newProject: Bool, projectId: ObjectId?) {
        self.newProject = newProject
        self.projectId = projectId
    }
    
    //MARK: Functions
    func resetForm(){
        if newProject {
            inputTextStringsController = ["","","0","",""]
            selectedCustomers = []
            selectContactsViewModel.selected = selectedCustomers
            projectTasks = []
        }
    }
    
    func setup(){
        if !newProject {
            if !fromNavigation {
                project = projectsObj.findProjects(projectId!)
                code = project![0].code
                title = project![0].title
                statusSelection = project![0].status
                startDate = project![0].startDate
                finishDate = project![0].finishDate
                selectedCustomers = projectsObj.convertCustomersListToArray(project![0].customers)
                selectContactsViewModel.selected = selectedCustomers
                projectTasks = projectsObj.convertProjectTasksListToArray(project![0].tasks)
                inputTextStringsController = [
                    code,
                    title,
                    "\(status)",
                    "\(startDate)",
                    "\(finishDate)"
                ]
            }
        }
     }
    
    func saveProject() {
        filledCode = true
        filledCode = true
        
        if  inputTextStringsController[0].isEmpty {
            filledCode = false
        }
        
        if  inputTextStringsController[1].isEmpty {
            filledTitle = false
        }
 
        let currProjectDataObj = Projects(
            customers:projectsObj.convertCustomersArrayToList(selectContactsViewModel.selected),
            code: inputTextStringsController[0],
            title: inputTextStringsController[1],
            status: statusSelection,
            startDate: startDate,
            finishDate: finishDate,
            tasks: projectsObj.convertProjectTasksArrayToList(projectTasks)
        )
 
        if filledCode && filledTitle && finishDate >= startDate {
            if newProject {
                projectsObj.createNewProjects(currProjectDataObj)
            } else {
                projectsObj.saveProjects(currProjectDataObj, projectId!)
            }
            showAlert = false
            dismissView.send()
        }
        else {
            if !filledCode || !filledTitle {
                alertMessage = "Please fill out all required fields"
            }
            else {
                alertMessage = "The start date must be before the finish date"
            }
            showAlert = true
        }
    }
     
    func deleteProject() {
        dismissView.send()
        projectsObj.deleteProjects(self.projectId!)
    }
}
