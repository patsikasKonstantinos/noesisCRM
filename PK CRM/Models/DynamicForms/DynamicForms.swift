//
//  DynamicForms.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 22/4/23.
//

import Foundation
import RealmSwift

class DynamicForms: Object , ObjectKeyIdentifiable {
    
    //MARK: Properties
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name:String
    @Persisted var isEmpty:Bool
    @Persisted var entries:List<DynamicFormsEntries>
    
    //MARK: Initialization
    convenience init(
        name:String,
        isEmpty:Bool,
        entries:List<DynamicFormsEntries>){
        self.init()
        self.name = name
        self.isEmpty = isEmpty
        self.entries = entries
    }
}
