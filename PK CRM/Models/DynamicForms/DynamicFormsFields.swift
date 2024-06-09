//
//  DynamicFormsFields.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 22/4/23.
//

import Foundation
import RealmSwift

class DynamicFormsFields: Object , ObjectKeyIdentifiable {
    
    //MARK: Properties
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name:String
    @Persisted var type:Int
    @Persisted var required:Bool
    @Persisted var position:Int
    @Persisted var fieldValue:DynamicFormsFieldsValue?

    //MARK: Initialization
    convenience init(
        name:String,
        type:Int,
        required:Bool,
        position:Int){
        self.init()
        self.name = name
        self.type = type
        self.required = required
        self.position = position
    }
}
