//
//  SelectContactsViewModel.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 18/6/23.
//

import Foundation
import RealmSwift

class SelectContactsViewModel: ObservableObject {
    @ObservedResults(Contacts.self) var allContacts
    
    //MARK: Published Properties
    @Published var selectedContact = 0
    @Published var showingAddNewContactSheet = false
    @Published var editExistedContactSheet = false
    @Published var selected:[Contacts]
    @Published var selectedContacts:[Contacts] = []
    @Published var contactsController:[Contacts] = []
    @Published var dynamicContactsIndex:Int = 0
    @Published var selectedDynamicContacts:[Int:[Contacts]] = [:]
    @Published var searchText = ""
    @Published var displaySearch = false
    @Published var navigationView = false
    
    //MARK: let Properties
    private let contactsFunctionality = ContactsFunctionality()
    private let projectsObj = ProjectsFunctionality()
    let types = Variables.types
    
    //MARK: var Properties
    var multiple:Bool
    var contactType:Int
    
    var contacts: [Contacts] {
        return Array(contactType != 3 ? allContacts.filter("type = %@", contactType).sorted(byKeyPath: "firstName", ascending: true) : allContacts.sorted(byKeyPath: "firstName", ascending: true))
    }
    
    var filteredContacts: [Contacts] {
        if searchText.isEmpty {
            return contacts
        } else {
            return contacts.filter { contact in
                contactsFunctionality.findContacts(searchText, contact)
            }
        }
    }
 
    //MARK: Initialization
    init(multiple: Bool, contactType: Int,selected:[Contacts]) {
        self.multiple = multiple
        self.contactType = contactType
        self.selected = selected
    }
    
    //MARK: Functions
    func setup(for index:Int,_ selectedContacts:[Contacts]){
        dynamicContactsIndex = index
        selected = selectedContacts
    }
 
    func isSelected(_ contact:Contacts) -> Bool {
        if selected.contains(where: { $0.id == contact.id }){
            return true
        }else{
            return false
        }
    }
    
    func selectContactsAction(_ contact:Contacts) -> [Contacts] {
        if multiple {
            if selected.contains(where: { $0.id == contact.id }) {
                selected.removeAll(where: { $0.id == contact.id })
            }
            else{
                selected.append(contact)
            }
        }
        else {
            if selected.count == 1 {
                if contact.id == selected[0].id {
                    selected.removeAll()
                }
                else{
                    selected.removeAll()
                    selected.append(contact)
                }
            }
            else{
                selected.removeAll()
                selected.append(contact)
            }
        }
        return selected
    }
}
