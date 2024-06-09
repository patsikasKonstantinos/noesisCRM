//
//  ProjectsCustomObj.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 18/5/23.
//

import Foundation
import RealmSwift

class ProjectsCustomObj: Object , ObjectKeyIdentifiable {
    
    //MARK: Properties
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var projects:List<Projects>
    
    //MARK: Initialization
    convenience init(projects:List<Projects>){
        self.init()
        self.projects = projects
    }
}
