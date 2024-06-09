//
//  CallViewModel.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 17/6/23.
//

import Foundation
import RealmSwift
import Combine

class CallViewModel: ObservableObject {
    
    //MARK: Published Properties
    @Published var fromNavigation = false
    @Published var call:Results<Calls>?
    @Published var selectedContacts: [Contacts] = []
    @Published var selectedUsers: [Contacts] = []
    @Published var date: Date = Date()
    @Published var comments: String = ""
    @Published var duration: Float = 0.0
    @Published var inputTextStringsController: [String] = ["", "", "", "", ""]
    @Published var alertTitle = "Success,"
    @Published var alertText = "Your Call Saved Successfully"
    @Published var showingAlert = false
    @Published var filledUser = true
    
    //MARK: let Properties
    private let dismissView = PassthroughSubject<Void, Never>()
    private let callsObj = CallsFunctionality()
    let listViewItems = Variables.callViewListItems
    
    //MARK: var Properties
    private var firstLoad: Bool = true
    private var newCall: Bool
    private var callId: ObjectId?
    var dismissRequest: AnyPublisher<Void, Never> {
        dismissView.eraseToAnyPublisher()
    }
    lazy var selectContactsViewModel: SelectContactsViewModel = {
           return SelectContactsViewModel(multiple: false, contactType: 3,selected: selectedContacts)
    }()
    
    lazy var selectUsersViewModel: SelectContactsViewModel = {
           return SelectContactsViewModel(multiple: false, contactType: 2,selected: selectedUsers)
    }()
     
    //MARK: Initialization
    init(newCall: Bool, callId: ObjectId?) {
        self.newCall = newCall
        self.callId = callId
        
    }

    //MARK: Functions
    func checkIfUserFieldIsFilled(){
        if !selectedUsers.isEmpty {
            filledUser = true
        }
    }
    
    func resetForm(){
        if newCall {
            filledUser = true
            showingAlert = false
            inputTextStringsController = ["", "", "", "", ""]
            selectedUsers = []
            selectedContacts = []
            date = Date()
        }
    }
    
    func setup(){
        if(!newCall){
            if !fromNavigation {
                call = callsObj.findCalls(callId!)
                selectedUsers = callsObj.convertCallContactsListToArray(call![0].users)
                selectedContacts = callsObj.convertCallContactsListToArray(call![0].customers)
                date = call![0].date
                comments = call![0].comments
                duration = call![0].duration
                inputTextStringsController=["","","\(date)","\(duration)", "\(comments)"]
            }
        }
    }

    func saveCall() {
        if !selectUsersViewModel.selected.isEmpty {
            let currCallDataObj = Calls(
                users: callsObj.convertCallContactsArrayToList(selectUsersViewModel.selected),
                customers: callsObj.convertCallContactsArrayToList(selectContactsViewModel.selected),
                date: date,
                comments: inputTextStringsController[4],
                duration: Float(inputTextStringsController[3]) ?? 0
            )

            if newCall {
                callsObj.createNewCalls(currCallDataObj)
            }
            else if let callId = callId {
                callsObj.saveCalls(currCallDataObj, callId)
            }
            
            filledUser = true
            showingAlert = false
            dismissView.send()
        } else {
            filledUser = false
            alertTitle = "Oops,"
            alertText = "Please fill out all required fields"
            showingAlert = true
        }
    }
}
