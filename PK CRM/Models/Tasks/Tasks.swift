//
//  Tasks.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 26/2/23.
//

import Foundation
 
import RealmSwift

class Tasks: Object , ObjectKeyIdentifiable {
    
    //MARK: Properties
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var code:String = ""
    @Persisted var title:String = ""
    @Persisted var status:Int = 0
    @Persisted var startDate:Date = Date()
    @Persisted var finishDate:Date = Date()
    @Persisted var comments:String = ""
    @Persisted var assignments:List<Contacts>

    //MARK: Initialization
    convenience init(
        code:String,
        title:String,
        status:Int,
        startDate:Date,
        finishDate:Date,
        comments:String,
        assignments:List<Contacts>){
        self.init()
        self.code = code
        self.title = title
        self.status = status
        self.startDate = startDate
        self.finishDate = finishDate
        self.comments = comments
        self.assignments = assignments
    }
}
