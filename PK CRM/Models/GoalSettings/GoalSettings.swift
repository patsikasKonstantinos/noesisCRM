//
//  GoalSettings.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 1/1/23.
//

import Foundation
import RealmSwift

class GoalSettings: Object , ObjectKeyIdentifiable {
    
    //MARK: Properties
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title:String
    @Persisted var project:List<Projects>
    @Persisted var initialMetric:Float
    @Persisted var currentMetric:Float
    @Persisted var type:Int
    @Persisted var startDate:Date
    @Persisted var endDate:Date
    @Persisted var complete:Bool
 
    //MARK: Initialization
    convenience init(title:String,project:List<Projects>,initialMetric:Float,currentMetric:Float,type:Int,startDate:Date,endDate:Date,complete:Bool){
        self.init()
        self.title = title
        self.project = project
        self.initialMetric = initialMetric
        self.currentMetric = currentMetric
        self.type = type
        self.startDate = startDate
        self.endDate = endDate
        self.complete = complete
    }
}
