//
//  RegisterResponse.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 16/7/23.
//
import Foundation

struct RegisterResponse: Codable {
    
    //MARK: Properties
    var success: Bool
    var id: Int?
    var name: String?
    var surname: String?
    var email: String?
    var message: String?
    var connectionError: Bool?
}
