//
//  DaysOff.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 1/1/23.
//

import Foundation
import RealmSwift

class DaysOff: Object , ObjectKeyIdentifiable {
    
    //MARK: Properties
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var users:List<Contacts>
    @Persisted var date:Date
    @Persisted var comments:String
    
    //MARK: Initialization
    convenience init(users:List<Contacts>,date:Date,comments:String){
        self.init()
        self.users = users
        self.date = date
        self.comments = comments
    }
}
