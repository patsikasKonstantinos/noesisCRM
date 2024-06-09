//
//  ContactFinancialDetailsViewModel.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 12/6/23.
//

import Foundation
import RealmSwift

class ContactFinancialDetailsViewModel: ObservableObject {
    
    //MARK: Published Properties
    @Published var allPaymentsList: [Payments]
    @Published var searchText = ""
    @Published var selectedPayment:Payments?
    @Published var addNewEntry = false
    
    //MARK: let Properties
    private let paymentObj = PaymentsFunctionality()
    let income: Bool
    let expenses: Bool
    
    //MARK: var Properties
    var contactId: ObjectId?

    var payments: [Payments] {
        return allPaymentsList.filter { $0.isIncome == income && $0.isExpenses == expenses}
    }

    var filteredPaymentsCount: Int {
        return payments.count
    }
    
    var filteredPayments: [Payments] {
        if searchText.isEmpty {
            return payments
         }
        else {
            return self.payments.filter { payment in
                paymentObj.findPayments(searchText: searchText,payment)
            }
        }
    }
    
    //MARK: Initialization
    init(allPaymentsList: [Payments], income: Bool, expenses: Bool, contactId: ObjectId?) {
        self.allPaymentsList = allPaymentsList
        self.income = income
        self.expenses = expenses
        self.contactId = contactId
    }

    //MARK: Functions
    func deletePayment(at offsets: IndexSet) {
        let index = offsets[offsets.startIndex]
//        let deletePaymentId = allPaymentsList[index].id
//        print("deletePaymentId \(deletePaymentId)")
        allPaymentsList.remove(at: index)
//        paymentObj.deletePayment(deletePaymentId)
    }
}
