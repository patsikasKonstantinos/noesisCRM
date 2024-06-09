//
//  CallsListViewModel.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 16/6/23.
//

import Foundation
import RealmSwift

class CallsListViewModel: ObservableObject {
    @ObservedResults(Calls.self) var allCalls
    
    //MARK: Published Properties
    @Published var shouldUpdateList:Bool = false
    @Published var selectedCall = 0
    @Published var showingAddNewCallSheet = false
    @Published var editExistedCallSheet = false
    @Published var callID: ObjectId?
    @Published var searchText = ""
    @Published var listCount:Int = 0
    @Published var showFilters:Bool = false
    @Published var filterStartDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @Published var filterFinishDate: Date =  Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
    @Published var filterCalls:Int = 0
    @Published var sortCalls:Int = 1
    @Published var addNewEntry = false
    
    //MARK: let Properties
    private let callsFunctionality: CallsFunctionality
    let calendar = Calendar.current
    let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
    
    //MARK: var Properties
    private var notificationToken:NotificationToken?
    var sortBy = "date"
    var ascending = false
    
    var calls: [Calls] {
        callsSort()
        return Array(allCalls.filter("date >= %@ AND date <= %@", filterStartDate,filterFinishDate).sorted(byKeyPath: "\(sortBy)", ascending: ascending))
    }
    
    var filteredCalls: [Calls] {
        if searchText.isEmpty {
            return calls
        }
        else {
            return calls.filter { call in
                callsFunctionality.findCalls(searchText: searchText, call)
            }
        }
    }
    
    //MARK: Initialization
    init(callsFunctionality: CallsFunctionality) {
        self.callsFunctionality = callsFunctionality
        notificationToken = RealmManager.shared.realm.observe { [weak self] (_ ,_)  in
            self?.objectWillChange.send()
        }
    }
 
    deinit {
        // Invalidate the token when the object is deallocated
        notificationToken?.invalidate()
    }
    
    //MARK: Functions
    func callsSort() {
        if sortCalls == 0 {
            ascending = true
        }
        else if sortCalls == 1 {
            ascending = false
        }
    }
 
    func updateListId(){
        shouldUpdateList.toggle()
        listCount = allCalls.count
    }
    
    func changeDateFormat(date: Date) -> String {
        return callsFunctionality.changeDateFormat(date: date)
    }
    
    func deleteCall(offsets: IndexSet) {
        let index = offsets[offsets.startIndex]
        let callId = calls[index].id
        callsFunctionality.deleteCalls(callId)
        updateListId()
    }
    
    func submitCallsFilter(_ filterStartDate:Date, _ filterFinishDate:Date, _ sortCalls:Int){
        self.filterStartDate = filterStartDate
        self.filterFinishDate = filterFinishDate
        self.sortCalls = sortCalls
        showFilters = false
    }
    
    func resetCallsFilters() -> (Date, Date, Int) {
        let reset = (previousMonth,nextMonth,1)
        return reset
    }
}
