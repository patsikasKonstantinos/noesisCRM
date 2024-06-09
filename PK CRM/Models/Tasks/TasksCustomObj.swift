//
//  TasksCustomObj.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 18/5/23.
//

import Foundation
 
import RealmSwift

class TasksCustomObj: Object , ObjectKeyIdentifiable {
    
    //MARK: Properties
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var tasks:List<Tasks>
   
    //MARK: Initialization
    convenience init(tasks:List<Tasks>){
        self.init()
        self.tasks = tasks
    }
}
