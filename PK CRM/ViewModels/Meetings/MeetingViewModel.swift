//
//  MeetingViewModel.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 16/6/23.
//

import Foundation
import RealmSwift
import Combine

class MeetingViewModel: ObservableObject {
    
    //MARK: Published Properties
    @Published var fromNavigation = false
    @Published var title: String = ""
    @Published var selectedContacts: [Contacts] = []
    @Published var date: Date = Date()
    @Published var comments: String = ""
    @Published var completed: Bool = false
    @Published var inputTextList: [Int: String] = [:]
    @Published var inputTextStringsController: [String] = ["", "", "", "", ""]
    @Published var selected:[Contacts] = []
    @Published var navigationView:Bool = false
    @Published var showingAlert = false
    @Published var filledTitle = true
    @Published var alertTitle = "Success,"
    @Published var alertText = "Your Meeting Saved Successfully"
    @Published var meeting:Results<Meetings>?
    
    //MARK: let Properties
    private let dismissView = PassthroughSubject<Void, Never>()
    private let meetingsFunctionality = MeetingsFunctionality()
    let listViewItems = Variables.meetingViewListItems
    
    //MARK: var Properties
    private var firstLoad: Bool = true
    var meetingId: ObjectId?
    var newMeeting: Bool
    
    var dismissRequest: AnyPublisher<Void, Never> {
        dismissView.eraseToAnyPublisher()
    }
    lazy var selectContactsViewModel: SelectContactsViewModel = {
           return SelectContactsViewModel(multiple: true, contactType: 3,selected: selected)
    }()
    
    //MARK: Initialization
    init(newMeeting: Bool, meetingId: ObjectId?) {
        self.newMeeting = newMeeting
        self.meetingId = meetingId

    }

    //MARK: Functions
    func resetForm(){
        if newMeeting {
            filledTitle = true
            showingAlert = false
            selectedContacts = []
            selectContactsViewModel.selected = selectedContacts
            inputTextStringsController = ["", "", "", "", ""]
            date = Date()
            completed = false
        }
    }
    
    func setup(){
        if !newMeeting {
            meeting = meetingsFunctionality.findMeetings(meetingId!)
            title = meeting![0].title
            selectedContacts = meetingsFunctionality.convertMeetingContactsListToArray(meeting![0].customers)
            selectContactsViewModel.selected = selectedContacts
            date = meeting![0].date
            comments = meeting![0].comments
            completed = meeting![0].completed
            inputTextStringsController = [title, "\(date)", "", "\(comments)", "\(completed)"]
        }
    }
    
    func saveMeeting() {
        if inputTextStringsController[0].isEmpty {
            filledTitle = false
        }

        let currMeetingDataObj = Meetings(
            title: inputTextStringsController[0],
            customers: meetingsFunctionality.convertMeetingContactsArrayToList(selectContactsViewModel.selected),
            date: date,
            comments: inputTextStringsController[3],
            completed: completed
        )

        if !inputTextStringsController[0].isEmpty {
            if newMeeting {
                meetingsFunctionality.createNewMeetings(currMeetingDataObj)
            }
            else if let meetingId = meetingId {
                meetingsFunctionality.saveMeetings(currMeetingDataObj, meetingId)
            }
            showingAlert = false
            dismissView.send()
        }
        else {
            alertTitle = "Oops,"
            alertText = "Please fill out all required fields"
            showingAlert = true
        }
    }
}
