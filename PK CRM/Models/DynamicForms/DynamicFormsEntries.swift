//
//  DynamicFormsEntries.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 22/4/23.
//

import Foundation
import RealmSwift

class DynamicFormsEntries: Object,ObjectKeyIdentifiable {
    
    //MARK: Properties
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var fields:List<DynamicFormsFields>

    //MARK: Initialization
    convenience init(
        fields:List<DynamicFormsFields>){
        self.init()
        self.fields = fields
    }
}
