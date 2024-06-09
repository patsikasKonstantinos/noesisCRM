//
//  DynamicFormsFieldsTypes.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 23/4/23.
//

import Foundation

class DynamicFormsFieldsTypes{
    
    //MARK: Properties
    var kind:Int
    var name:String
    
    //MARK: Initialization
    init(kind: Int, name: String) {
        self.kind = kind
        self.name = name
    }
}
