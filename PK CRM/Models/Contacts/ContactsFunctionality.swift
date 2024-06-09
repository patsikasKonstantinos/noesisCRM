//
//  ContactsFunctionality.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 2/10/22.
//

import Foundation
import RealmSwift

class ContactsFunctionality:ObservableObject{
    
    //MARK: Properties
    let realm = RealmManager.shared.realm
 
    //MARK: Functions
    func convertContactsListToArray(_ list:List<Contacts>) -> [Contacts] {
        var array:[Contacts] = []
        array.append(contentsOf:list)
        return array
    }
    
    func convertContactsArrayToList(_ array:[Contacts]) -> List<Contacts> {
         let list = List<Contacts>()
         list.append(objectsIn: array)
         return list
    }
    
    //Return Contacts
    func findContacts() -> Results<Contacts> {
        let contacts = realm.objects(Contacts.self).sorted(byKeyPath: "firstName", ascending: true)
        return contacts
    }
    
    //Return Specific Contacts
    func findContacts(_ searchText:String,_ initContacts:Results<Contacts>) -> Results<Contacts>  {
        let contactsSearch = initContacts.where {
            $0.firstName.contains(searchText) ||
            $0.surnName.contains(searchText)  ||
            $0.telephoneNumber.contains(searchText)  ||
            $0.mobilePhoneNumber.contains(searchText)  ||
            $0.taxId.contains(searchText)  ||
            $0.identityId.contains(searchText)
         }
         return contactsSearch
    }
    
    //Return Specific Contact Id
    func findContacts(_ contactId:ObjectId) -> Results<Contacts>  {
        let allContactsObj = realm.objects(Contacts.self)
        let contactFound = allContactsObj.where {
            $0.id == contactId
        }
        return contactFound
    }
    
    //Return Specific Contact Id
    func findContactsArrayFormat(_ contactId:ObjectId) -> [Contacts]  {
        var list:[Contacts] = []
        let allContactsObj = realm.objects(Contacts.self)
        let contactFound = allContactsObj.where {$0.id == contactId}
        for contact in contactFound {
            list.append(contact)
        }
        return list
    }
    
    //Find Contact From Specific Search
    func findContacts(_ searchText: String, _ contact: Contacts) -> Bool {
        var returnValue: Bool = false
        let searchWords = searchText.split(separator: " ")
        for word in searchWords {
            if contact.firstName.contains(word) ||
                contact.surnName.contains(word) ||
                contact.telephoneNumber.contains(word) ||
                contact.mobilePhoneNumber.contains(word) ||
                contact.city.contains(word) ||
                contact.address.contains(word) ||
                contact.postCode.contains(word) ||
                contact.taxId.contains(word) {
                returnValue = true
            }
        }
        return returnValue
    }
    
    //Create a new Contacts
    func createNewContacts(_ contact:Contacts, _ contactPayments:[Payments]){
        let paymentFunctionalityObj = PaymentsFunctionality()
        let contactObj = Contacts(
            type: contact.type,
            firstName: contact.firstName,
            surnName: contact.surnName,
            telephoneNumber: contact.telephoneNumber,
            mobilePhoneNumber: contact.mobilePhoneNumber,
            country: contact.country,
            state: contact.state,
            city: contact.city,
            address: contact.address,
            postCode: contact.postCode,
            taxId: contact.taxId,
            identityId: contact.identityId,
            active:contact.active
        )
 
        for payment in contactPayments {
            payment.customers = convertContactsArrayToList([contactObj])
            paymentFunctionalityObj.createNewPayment(payment,true)
        }
        
        try! realm.write {
            realm.create(Contacts.self, value: contactObj, update: .modified)
       }
    }
    
    //Delete Contact
    func deleteContacts(_ contactId:ObjectId){
        let allContactsObj = realm.objects(Contacts.self)
        let contactDelete = allContactsObj.where {$0.id == contactId}
        try! realm.write {
            realm.delete(contactDelete)
        }
    }
    
    //Find Payment Contact
    func findAllContactPaypemnts(_ contactId:ObjectId,_ payments:Results<Payments>) -> [Payments] {
        var contactPayments: [Payments] = []
        for payment in payments.sorted(byKeyPath: "date", ascending: false).where({ $0.customers.id == contactId}) {
            contactPayments.append(payment)
        }
        return contactPayments
    }
    
    //Update current Contacts
    func saveContacts(_ contact:Contacts,_ contactId:ObjectId, _ contactPayments:[Payments]) {
        let paymentFunctionalityObj = PaymentsFunctionality()
        let contactObj = Contacts(
            type: contact.type,
            firstName: contact.firstName,
            surnName: contact.surnName,
            telephoneNumber: contact.telephoneNumber,
            mobilePhoneNumber: contact.mobilePhoneNumber,
            country: contact.country,
            state: contact.state,
            city: contact.city,
            address: contact.address,
            postCode: contact.postCode,
            taxId: contact.taxId,
            identityId: contact.identityId,
            active:contact.active
        )
        
        contactObj.id = contactId
        if contactPayments.count > 0{
            for payment in contactPayments {
                paymentFunctionalityObj.createNewPayment(payment,true)
            }
        }
        paymentFunctionalityObj.deletePaymentFromSpecificContact(contactId,contactPayments)
        try! realm.write {
             realm.create(Contacts.self, value: contactObj, update: .modified)
        }
    }
}
