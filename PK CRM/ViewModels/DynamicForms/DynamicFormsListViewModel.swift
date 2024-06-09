//
//  DynamicFormsListViewModel.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 16/6/23.
//

import Foundation
import RealmSwift

class DynamicFormsListViewModel: ObservableObject {
    @ObservedResults(DynamicForms.self) var allDynamicForms
    
    //MARK: Published Properties
    @Published var shouldUpdateList:Bool = false
    @Published var selectedDynamicForm = 0
    @Published var showingAddNewDynamicFormSheet = false
    @Published var editExistedDynamicFormSheet = false
    @Published var dynamicFormID: ObjectId?
    @Published var searchText = ""
    @Published var listCount:Int = 0
    @Published var addNewEntry = false
    
    //MARK: let Properties
    private let dynamicFormsFunctionality: DynamicFormsFunctionality
    
    //MARK: var Properties
    private var notificationToken:NotificationToken?
    var dynamicForms: [DynamicForms] {
        return Array(allDynamicForms.sorted(byKeyPath: "name", ascending: true))
    }
    
    var filteredDynamicForms: [DynamicForms] {
        if searchText.isEmpty {
            return dynamicForms
        }
        else {
            return dynamicForms.filter { dynamicForm in
                dynamicFormsFunctionality.findDynamicForms(searchText: searchText, dynamicForm)
            }
        }
    }
    
    //MARK: Initialization
    init(dynamicFormsFunctionality: DynamicFormsFunctionality) {
        self.dynamicFormsFunctionality = dynamicFormsFunctionality
        notificationToken = RealmManager.shared.realm.observe { [weak self] (_ ,_)  in
            self?.objectWillChange.send()
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
     
    //MARK: Functions
    func updateListId(){
        shouldUpdateList.toggle()
        listCount = allDynamicForms.count
    }
    
    func deleteDynamicForm(offsets: IndexSet) {
        let index = offsets[offsets.startIndex]
        let dynamicFormId = dynamicForms[index].id
        dynamicFormsFunctionality.deleteDynamicForms(dynamicFormId)
        updateListId()
    }
}
