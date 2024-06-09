//
//  TaskForm.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 27/2/23.
//

import Foundation

class TaskForm {
    
    //MARK: Properties
    var name:String
    var type:Int
    
    //MARK: Initialization
    init(name: String, type: Int) {
        self.name = name
        self.type = type
    }
}
