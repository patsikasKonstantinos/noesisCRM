//
//  LoginResponse.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 14/7/23.
//

import Foundation

struct LoginResponse: Codable {
    
    //MARK: Properties
    var success: Bool
    var id: Int?
    var name: String?
    var surname: String?
    var email: String?
    var connectionError: Bool?
}
