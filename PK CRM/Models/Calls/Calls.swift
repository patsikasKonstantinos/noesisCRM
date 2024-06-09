//
//  Calls.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 1/1/23.
//

import Foundation
import RealmSwift

class Calls: Object , ObjectKeyIdentifiable {
    
    //MARK: Properties
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var users:List<Contacts>
    @Persisted var customers:List<Contacts>
    @Persisted var date:Date
    @Persisted var comments:String
    @Persisted var duration:Float

    //MARK: Initialization
    convenience init(users:List<Contacts>,customers:List<Contacts>,date:Date,comments:String,duration:Float){
        self.init()
        self.users = users
        self.customers = customers
        self.date = date
        self.comments = comments
        self.duration = duration
    }
}
