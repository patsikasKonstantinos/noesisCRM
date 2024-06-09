//
//  PaymentForm.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 12/3/23.
//

import Foundation

class PaymentForm {
    
    //MARK: Properties
    var name:String
    var type:Int
    
    //MARK: Initialization
    init(name: String, type: Int) {
        self.name = name
        self.type = type
    }
}
