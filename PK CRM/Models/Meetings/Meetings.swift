//
//  Meetings.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 1/1/23.
//

import Foundation
import RealmSwift

class Meetings: Object , ObjectKeyIdentifiable {
    
    //MARK: Properties
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title:String
    @Persisted var customers:List<Contacts>
    @Persisted var date:Date
    @Persisted var comments:String
    @Persisted var completed:Bool

    //MARK: Initialization
    convenience init(title:String,customers:List<Contacts>,date:Date,comments:String,completed:Bool){
        self.init()
        self.title = title
        self.customers = customers
        self.date = date
        self.comments = comments
        self.completed = completed
    }
}
