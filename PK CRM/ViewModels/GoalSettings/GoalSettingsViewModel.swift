//
//  GoalSettingsViewModel.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 17/6/23.
//

import Foundation
import RealmSwift
import Combine

class GoalSettingsViewModel: ObservableObject {
 
    //MARK: Published Properties
    @Published var filledTitle = true
    @Published var fromNavigation = false
    @Published var goalSettings:Results<GoalSettings>?
    @Published var selectedContacts: [Contacts] = []
    @Published var selectedUsers: [Contacts] = []
    @Published var selectedProjects:[Projects] = []
    @Published var date: Date = Date()
    @Published var comments: String = ""
    @Published var duration: Float = 0.0
    @Published var inputTextStringsController: [String] = ["", "", "", "", ""]
    @Published var alertTitle = "Success,"
    @Published var alertText = "Your GoalSettings Saved Successfully"
    @Published var showingAlert = false
    @Published var filledUser = true
    @Published var startDate:Date = Date()
    @Published var endDate:Date = Date()
    @Published var completed:Bool = false
    @Published var typeSelection:Int = 0
    
    //MARK: let Properties
    private let goalSettingsObj = GoalSettingsFunctionality()
    private let projectsObj = ProjectsFunctionality()
    private let dismissView = PassthroughSubject<Void, Never>()
    let listViewItems = Variables.goalSettingsViewListItems
    let goalSettingsTypes = Variables.goalSettingsTypes
    
    //MARK: var Properties
    private var firstLoad: Bool = true
    private var newGoalSettings: Bool
    private var goalSettingsId: ObjectId?
    var dismissRequest: AnyPublisher<Void, Never> {
        dismissView.eraseToAnyPublisher()
    }
    lazy var selectProjectsViewModel: SelectProjectsViewModel = {
           return SelectProjectsViewModel(multiple: false)
    }()
    
    //MARK: Initialization
    init(newGoalSettings: Bool, goalSettingsId: ObjectId?) {
        self.newGoalSettings = newGoalSettings
        self.goalSettingsId = goalSettingsId
    }

    //MARK: Functions
    func checkIfUserFieldIsFilled(){
        if !selectedUsers.isEmpty {
            filledUser = true
        }
    }
    
    func resetForm(){
        if newGoalSettings {
            filledUser = true
            showingAlert = false
            inputTextStringsController = ["", "", "", "", ""]
            selectedProjects = []
            selectProjectsViewModel.selected = selectedProjects
        }
    }
    
    func setup(){
        if(!newGoalSettings && !fromNavigation){
            goalSettings = goalSettingsObj.findGoalSettings(goalSettingsId!)
            inputTextStringsController[0] = goalSettings![0].title
            selectedProjects = projectsObj.convertProjectListToArray(goalSettings![0].project)
            selectProjectsViewModel.selected = selectedProjects
            inputTextStringsController[3] = String(goalSettings![0].initialMetric)
            inputTextStringsController[4] = String(goalSettings![0].currentMetric)
            inputTextStringsController[2] = String(goalSettings![0].type)
            startDate = goalSettings![0].startDate
            endDate = goalSettings![0].endDate
            completed = goalSettings![0].complete
            inputTextStringsController=[inputTextStringsController[0],"","\(inputTextStringsController[2])","\(inputTextStringsController[3])", "\(inputTextStringsController[4])","\(startDate)","\(endDate)","\(completed)"]
        }
    }

    func saveGoalSettings() {
       let currGoalSettingsDataObj = GoalSettings(
           title:inputTextStringsController[0],
           project: projectsObj.convertProjectsArrayToList(selectProjectsViewModel.selected),
           initialMetric: Float(inputTextStringsController[3]) ?? 0,
           currentMetric: Float(inputTextStringsController[4]) ?? 0,
           type: Int(inputTextStringsController[2]) ?? 0,
           startDate: startDate,
           endDate: endDate,
           complete:completed
       )
       
       if !inputTextStringsController[0].isEmpty &&
           endDate >= startDate {
           if newGoalSettings {
               goalSettingsObj.createNewGoalSettings(currGoalSettingsDataObj)
           }
           else{
               goalSettingsObj.saveGoalSettings(currGoalSettingsDataObj,goalSettingsId!)
           }
           filledTitle = true
           showingAlert = false
           dismissView.send()
       }
        else{
            
           if inputTextStringsController[0].isEmpty  {
               alertText = "Please fill out all required fields"
               filledTitle = false
           }else{
               alertText = "Τhe start date must be before the finish date"
               filledTitle = true
           }
           showingAlert = true
       }
    }
}
