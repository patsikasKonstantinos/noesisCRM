//
//  Evaluations.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 1/1/23.
//

import Foundation
import RealmSwift

class Evaluations: Object,ObjectKeyIdentifiable {
    
    //MARK: Properties
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title:String
    @Persisted var contact:List<Contacts>
    @Persisted var startDate:Date
    @Persisted var endDate:Date
    @Persisted var date:Date
    @Persisted var evaluationsCategories:List<EvaluationsCategories>
    @Persisted var comments:String
    
    //MARK: Initialization
    convenience init(title:String,contact:List<Contacts>,startDate:Date,endDate:Date,date:Date,evaluationsCategories:List<EvaluationsCategories>,comments:String){
        self.init()
        self.title = title
        self.contact = contact
        self.startDate = startDate
        self.endDate = endDate
        self.date = date
        self.evaluationsCategories = evaluationsCategories
        self.comments = comments
    }
}
