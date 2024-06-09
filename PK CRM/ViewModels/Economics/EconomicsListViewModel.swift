//
//  EconomicsListViewModel.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 14/6/23.
//

import Foundation
import RealmSwift

class EconomicsListViewModel: ObservableObject {
    @ObservedResults(Payments.self) var allPayments
    
    //MARK: Published Properties
    @Published var allPaymentsList: [Payments] = []
    @Published var searchText = ""
    @Published var listCount:Int = 0
    @Published var shouldUpdateList:Bool = false
    @Published var selectedPayment:Payments?
    @Published var addNewEntry = false
    
    //MARK: let Properties
    private let paymentsFunctionality = PaymentsFunctionality()
    let income: Bool
    let expenses: Bool
    
    //MARK: var Properties
    private var notificationToken:NotificationToken?
    
    var filteredPayments: [Payments] {
        if searchText.isEmpty {
            return payments
        }
        else {
            return payments.filter { payment in
                paymentsFunctionality.findPayments(searchText:searchText, payment)
            }
        }
        
    }
    var payments: [Payments] {
        return Array(allPayments.sorted(byKeyPath: "date", ascending: false).where
                     {$0.isIncome == income && $0.isExpenses == expenses})
    }
    
    //MARK: Initialization
    init(income: Bool, expenses: Bool) {
        self.income = income
        self.expenses = expenses
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
        listCount = allPayments.count
    }
    
    func deletePayment(offsets: IndexSet) {
        let index = offsets[offsets.startIndex]
        let paymentId = payments[index].id
        paymentsFunctionality.deletePayment(paymentId)
        updateListId()
    }
}
