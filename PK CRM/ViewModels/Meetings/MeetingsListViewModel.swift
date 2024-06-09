//
//  MeetingsListViewModel.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 16/6/23.
//

import Foundation
import RealmSwift

class MeetingsListViewModel: ObservableObject {
    @ObservedResults(Meetings.self) var allMeetings
    
    //MARK: Published Properties
    @Published var shouldUpdateList:Bool = false
    @Published var selectedMeeting = 0
    @Published var showingAddNewMeetingSheet = false
    @Published var editExistedMeetingSheet = false
    @Published var meetingID: ObjectId?
    @Published var searchText = ""
    @Published var listCount:Int = 0
    @Published var showFilters:Bool = false
    @Published var filterStartDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @Published var filterFinishDate: Date =  Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
    @Published var filterMeetings:Int = 0
    @Published var addNewEntry = false
    @Published var sortMeetings:Int = 1
    
    //MARK: let Properties
    private let meetingsFunctionality: MeetingsFunctionality
    let calendar = Calendar.current
    let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
    
    //MARK: var Properties
    private var notificationToken:NotificationToken?
    var sortBy = "date"
    var ascending = false
    
    var meetings: [Meetings] {
        meetingsSort()
        return Array(allMeetings.filter("date >= %@ AND date <= %@", filterStartDate,filterFinishDate).sorted(byKeyPath: "\(sortBy)", ascending: ascending))
    }
    
    var filteredMeetings: [Meetings] {
        if searchText.isEmpty {
            return meetings
        } else {
            return meetings.filter { meeting in
                meetingsFunctionality.findMeetings(searchText: searchText, meeting)
            }
        }
    }

    //MARK: Initialization
    init(meetingsFunctionality:MeetingsFunctionality){
        self.meetingsFunctionality = meetingsFunctionality
        notificationToken = RealmManager.shared.realm.observe { [weak self] (_ ,_)  in
            self?.objectWillChange.send()
        }
       
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    //MARK: Functions
    func meetingsSort() {
        if sortMeetings == 0 {
            ascending = true
        }
        else if sortMeetings == 1 {
            ascending = false
        }
    }
 
    func updateListId(){
        shouldUpdateList.toggle()
        listCount = allMeetings.count
    }
    
    func changeDateFormat(date: Date) -> String {
        return meetingsFunctionality.changeDateFormat(date: date)
    }
    
    func deleteMeeting(offsets: IndexSet) {
        let index = offsets[offsets.startIndex]
        let meetingId = meetings[index].id
        meetingsFunctionality.deleteMeetings(meetingId)
        updateListId()
    }
    
    func submitMeetingsFilter(_ filterStartDate:Date, _ filterFinishDate:Date, _ sortMeetings:Int){
        self.filterStartDate = filterStartDate
        self.filterFinishDate = filterFinishDate
        self.sortMeetings = sortMeetings
        showFilters = false
    }
    
    func resetMeetingsFilters() -> (Date, Date, Int) {
        let reset = (previousMonth,nextMonth,1)
        return reset
    }
}
