//
//  ContactsViewModel.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 11/6/23.
//

import Foundation
import RealmSwift

class ContactsListViewModel: ObservableObject {
    @ObservedResults(Contacts.self) var allContacts
    
    //MARK: Published Properties
    @Published var searchText = ""
    @Published var listCount:Int = 0
    @Published var shouldUpdateList:Bool = false
    @Published var showingAlert:Bool = false
    @Published var addNewEntry = false
    @Published var selectedContactType = 0
    
    //MARK: let Properties
    private var notificationToken:NotificationToken?
    private let contactsFunctionality: ContactsFunctionality
    
    //MARK: var Properties
    var contacts: [Contacts] {
        var contactTypeFilter = 0
        if selectedContactType > 0 {
            contactTypeFilter = selectedContactType - 1
            return Array(allContacts.filter("type = %@", contactTypeFilter).sorted(byKeyPath: "firstName", ascending: true) )
        }
        else{
            return Array(allContacts.sorted(byKeyPath: "firstName", ascending: true))
        }
    }
    
    var filteredContacts: [Contacts] {
        if searchText.isEmpty {
            return contacts
        }
        else {
            return contacts.filter { contact in
                contactsFunctionality.findContacts(searchText, contact)
            }
        }
    }
    
    //MARK: Initialization
    init(contactsFunctionality: ContactsFunctionality) {
        self.contactsFunctionality = contactsFunctionality
        notificationToken = RealmManager.shared.realm.observe { [weak self] (_ ,_)  in
            self?.objectWillChange.send()
        }
    }
    
    deinit {
        // Invalidate the token when the object is deallocated
        notificationToken?.invalidate()
    }
 
    //MARK: Functions
    func updateListId(){
        shouldUpdateList.toggle()
        listCount = allContacts.count
    }
    
    func deleteContacts(offsets: IndexSet) {
        let index = offsets[offsets.startIndex]
        let contactId = contacts[index].id
        contactsFunctionality.deleteContacts(contactId)
        updateListId()
    }
}
