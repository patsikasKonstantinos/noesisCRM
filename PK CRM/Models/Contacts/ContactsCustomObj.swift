//
//  ContactsCustomObj.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 18/5/23.
//

import Foundation
import RealmSwift

class ContactsCustomObj: Object , ObjectKeyIdentifiable {
    
    //MARK: Properties
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var contacts:List<Contacts>
    
    //MARK: Initialization
    convenience init(contacts:List<Contacts>){
        self.init()
        self.contacts = contacts
    }
}
