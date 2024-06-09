//
//  Evaluations.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 1/1/23.
//

import Foundation
import RealmSwift

class EvaluationsCategories: Object , ObjectKeyIdentifiable {
    
    //MARK: Properties
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var category:Int
    @Persisted var categoryEvaluation:Float
    
    //MARK: Initialization
    convenience init(category:Int,categoryEvaluation:Float){
        self.init()
        self.category = category
        self.categoryEvaluation = categoryEvaluation
    }
}
