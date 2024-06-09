//
//  DynamicFormsValue.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 22/4/23.
//

import Foundation
import RealmSwift

class DynamicFormsFieldsValue: Object , ObjectKeyIdentifiable {
    
    //MARK: Properties
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var fieldValue:AnyRealmValue
    
    //MARK: Initialization
    convenience init(fieldValue:AnyRealmValue){
        self.init()
        self.fieldValue = fieldValue
    }
}
