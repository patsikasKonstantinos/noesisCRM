//
//  EconomicsContactSummationViewModel.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 27/6/23.
//

import Foundation
import RealmSwift

class EconomicsContactSummationViewModel: ObservableObject {
    
    //MARK: Published Properties
    @Published var sums:[Int:String] = [:]
    
    //MARK: let Properties
    private let paymentsObj = PaymentsFunctionality()
    let allPaymentsList:[Payments]
 
    //MARK: Initialization
    init(allPaymentsList: [Payments]) {
        self.allPaymentsList = allPaymentsList
    }
    
    //MARK: Functions
    func setup(){
        sums = paymentsObj.findContactPaymentsSums(allPaymentsList.filter { !$0.isInvalidated })
    }
    
}
