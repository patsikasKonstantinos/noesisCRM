//
//  ContactPayments.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 20/3/23.
//

import Foundation
import RealmSwift

class ContactPayments: ObservableObject {
    
    //MARK: Properties
    @Published var payments: Payments?
    @Published var paymentId: ObjectId?
    @Published var contactId: ObjectId?
}
