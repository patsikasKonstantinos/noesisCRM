//
//  ContactsViewModel.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 11/6/23.
//

import Foundation
import RealmSwift
import Combine

class ContactViewModel: ObservableObject {
    @ObservedResults(Payments.self) var allPayments
    
    //MARK: Published Properties
    @Published var contactId: ObjectId?
    @Published var contact: Results<Contacts>?
    @Published var allPaymentsList: [Payments] = []
    @Published var filledName = true
    @Published var filledSurname = true
    @Published var isActive = false
    @Published var showingAlert = false
    @Published var countrySelection = 0
    @Published var typeSelection = 0
    @Published var inputTextStringsController: [String] = Array(repeating: "", count: 12)
    @Published var alertTitle = "Success,"
    @Published var alertText = "Your Contact Saved Successfully"
    @Published var name: String = ""
    @Published var surname: String = ""
    @Published var telephone:  String = ""
    @Published var mobile: String = ""
    @Published var country: Int = 0
    @Published var type: Int = 0
    @Published var contactTypeFilter: Int?
    @Published var state: String = ""
    @Published var city: String = ""
    @Published var address: String = ""
    @Published var postCode: String = ""
    @Published var taxId: String = ""
    @Published var identityId: String = ""
    @Published var active = false
    @Published var dismiss = false
    
    //MARK: let Properties
    private let deletePaymentItem = PassthroughSubject<Void, Never>()
    private let dismissView = PassthroughSubject<Void, Never>()
    private let contactsObj = ContactsFunctionality()
    private let paymentObj = PaymentsFunctionality()
    let listViewItems = Variables.contactViewListItems
    let countries = Counries.countries
    let types = Variables.types
    
    //MARK: var Properties
    private var firstLoad = true
    var newContact:Bool
    var initPaymentsList:Bool
    var income:Bool = false
    var expenses:Bool = false
    var openedTab:Int = 1
    
    var paymentViewModelEdit = PaymentViewModel(
       selectedPayment: nil,
       contactId: nil,
       newPayment: false,
       isIncome: false,
       isExpenses: false,
       hiddenContacts: true
   )
   
   var paymentViewModelNew =  PaymentViewModel(
       selectedPayment: nil,
       contactId: nil,
       newPayment: true,
       isIncome: false,
       isExpenses: false,
       hiddenContacts: true
   )
    
    var dismissRequest: AnyPublisher<Void, Never> {
         dismissView.eraseToAnyPublisher()
    }
    
    var deletePaymentRequest: AnyPublisher<Void, Never> {
        deletePaymentItem.eraseToAnyPublisher()
    }
    
    //MARK: Initialization
    init(contactId: ObjectId?,newContact:Bool,initPaymentsList:Bool,contactTypeFilter:Int?) {
        self.contactId = contactId
        self.newContact = newContact
        self.initPaymentsList = initPaymentsList
        self.contactTypeFilter = contactTypeFilter
        if let contactId = contactId {
            contact = contactsObj.findContacts(contactId)
        }
    }
 
    //MARK: Functions
    
    func checkTab(_ openTab:Int){
        openedTab = openTab
        if openedTab == 2 || openedTab == 3 {
            paymentViewModelNew.isIncome = openedTab == 2 ? true : false
            paymentViewModelNew.isExpenses = openedTab == 2 ? false : true
        }
        paymentViewModelNew.contactId = contactId
        paymentViewModelEdit.contactId = contactId
        

    }
    
    func paymentsCount(_ paymentsList: [Payments], _ openedTab:Int) -> Int {
        var count = 0
        income = false
        expenses = false
        if openedTab == 2 {
             income = true
        }
        else if openedTab == 3 {
             expenses = true
        }
        
        for payment in paymentsList {
            if !payment.isInvalidated{
                if payment.isIncome == income &&
                   payment.isExpenses == expenses &&
                   !payment.isInvalidated {
                    count += 1
                }
            }
        }
        
        return count
    }
    
    func filteredPayments(_ payment: Payments, _ openedTab:Int) -> Bool {
        return  payment.isIncome == true && payment.isExpenses == false && openedTab == 2
        || payment.isIncome == false && payment.isExpenses == true && openedTab == 3  ? true : false
    }
    
    var validPaymentsList:[Payments]{
        return allPaymentsList.filter { !$0.isInvalidated }
    }
 
    func saveContact() {
        // Perform validation checks
        if contactIsValid() {
            let currContactDataObj = Contacts(
                type: typeSelection,
                firstName: inputTextStringsController[1],
                surnName: inputTextStringsController[2],
                telephoneNumber: inputTextStringsController[3],
                mobilePhoneNumber: inputTextStringsController[4],
                country: countrySelection,
                state: inputTextStringsController[6],
                city: inputTextStringsController[7],
                address: inputTextStringsController[8],
                postCode: inputTextStringsController[9],
                taxId: inputTextStringsController[10],
                identityId: inputTextStringsController[11],
                active: isActive
            )
            if let contactId = contactId {
                contactsObj.saveContacts(currContactDataObj, contactId, validPaymentsList)
            }
            else {
                contactsObj.createNewContacts(currContactDataObj, validPaymentsList)
            }
            dismissView.send()
        }
        else {
        // Show alert for required fields
            alertTitle = "Oops,"
            alertText = "Please fill out all required fields"
            showingAlert = true
        }
    }
    
    func setup(){
        if !newContact {
            if firstLoad {
                contact = contactsObj.findContacts(contactId!)
                type = contact![0].type
                isActive = contact![0].active
                name = contact![0].firstName
                surname = contact![0].surnName
                telephone = contact![0].telephoneNumber
                mobile = contact![0].mobilePhoneNumber
                country = contact![0].country
                state = contact![0].state
                city = contact![0].city
                address = contact![0].address
                postCode = contact![0].postCode
                taxId = contact![0].taxId
                identityId = contact![0].identityId
                active = contact![0].active
                countrySelection = country
                typeSelection = type

                inputTextStringsController = ["\(contact![0].type)", name, surname, telephone, mobile, "\(contact![0].country)", state, city, address, postCode, taxId, identityId, "\(contact![0].active)"]

                if initPaymentsList {
                    allPaymentsList = contactsObj.findAllContactPaypemnts(contactId!,allPayments)
                    initPaymentsList = false
                }
                firstLoad = false
            }
        }
        else{
            if let contactType = contactTypeFilter {
                if contactType > 0 {
                    inputTextStringsController[0] = "\(contactType - 1)"
                    typeSelection = Int(inputTextStringsController[0])!
                }
             }
        }
    }
    
    private func contactIsValid() -> Bool {
        filledName = !inputTextStringsController[1].isEmpty
        filledSurname = !inputTextStringsController[2].isEmpty
        return filledName && filledSurname
    }
}
