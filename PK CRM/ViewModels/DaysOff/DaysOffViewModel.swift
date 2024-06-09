//
//  DaysOffViewModel.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 17/6/23.
//

 
import Foundation
import RealmSwift
import Combine

class DaysOffViewModel: ObservableObject {
    
    //MARK: Published Properties
    @Published var date: Date
    @Published var selectedUsers: [Contacts] = []
    @Published var inputTextStringsController: [String] = ["", "", ""]
    @Published var showingAlert = false
    @Published var filledUser = true
    @Published var alertTitle = "Success"
    @Published var alertText = "Your DaysOff Saved Successfully"
    @Published var fromNavigation = false
    
    //MARK: let Properties
    private let daysOffFunctionality = DaysOffFunctionality()
    private let dismissView = PassthroughSubject<Void, Never>()

    //MARK: var Properties
    private var daysOff: Results<DaysOff>?
    private var comments: String = ""
    private var firstLoad: Bool = true
    var listViewItems = Variables.daysOffViewListItems

    var dismissRequest: AnyPublisher<Void, Never> {
        dismissView.eraseToAnyPublisher()
    }
    
    lazy var selectUsersViewModel: SelectContactsViewModel = {
           return SelectContactsViewModel(multiple: false, contactType: 2,selected: selectedUsers)
    }()
    
    //MARK: Initialization
    init(date: Date) {
        self.date = date
    }
    
    //MARK: Functions
    func resetForm(){
        selectedUsers = []
        inputTextStringsController = ["", "", ""]
        
    }
    
    func setup(){
          if !fromNavigation {
              daysOff = daysOffFunctionality.findDaysOff(date)
              if !daysOff!.isEmpty {
                  selectedUsers = daysOffFunctionality.convertDaysOffContactsListToArray(daysOff![0].users)
                  date = daysOff![0].date
                  comments = daysOff![0].comments
                  inputTextStringsController=["\(date)","","\(comments)"]
              }
          }
    }
    
    func loadDaysOff() {
        daysOff = daysOffFunctionality.findDaysOff(date)
        if !daysOff!.isEmpty {
            selectedUsers = daysOffFunctionality.convertDaysOffContactsListToArray(daysOff![0].users)
            date = daysOff![0].date
            inputTextStringsController = ["\(date)", "", "\(daysOff![0].comments)"]
        }
    }
    
    func saveDaysOff() {
        let currDayOffDataObj = DaysOff(
            users: daysOffFunctionality.convertContactsArrayToList(selectUsersViewModel.selected),
            date: date,
            comments: inputTextStringsController[2]
        )
        daysOffFunctionality.saveDaysOff(currDayOffDataObj)
        dismissView.send()
    }
}
