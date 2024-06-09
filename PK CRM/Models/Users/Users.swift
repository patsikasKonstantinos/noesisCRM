//
//  Users.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 27/6/23.
//

import Foundation

class Users: Codable{
    var id:Int
    var email:String
    var name:String
    var surname:String

    
    init(id: Int, email: String, name: String, surname: String) {
        self.id = id
        self.email = email
        self.name = name
        self.surname = surname
    }
    
}
