//
//  Projects.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 1/1/23.
//

import Foundation
import RealmSwift

class Projects: Object , ObjectKeyIdentifiable {
    
    //MARK: Properties
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var customers:List<Contacts>
    @Persisted var code:String = ""
    @Persisted var title:String = ""
    @Persisted var status:Int = 0
    @Persisted var startDate:Date = Date()
    @Persisted var finishDate:Date = Date()
    @Persisted var tasks:List<Tasks>

    //MARK: Initialization
    convenience init(
        customers:List<Contacts>,
        code:String,
        title:String,
        status:Int,
        startDate:Date,
        finishDate:Date,
        tasks:List<Tasks>){
        self.init()
        self.customers = customers
        self.code = code
        self.title = title
        self.status = status
        self.startDate = startDate
        self.finishDate = finishDate
        self.tasks = tasks
    }
}
