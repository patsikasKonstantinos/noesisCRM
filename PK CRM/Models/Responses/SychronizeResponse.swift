//
//  SychronizeResponse.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 23/7/23.
//

import Foundation

class SychronizeResponse {
    
    //MARK: Properties
    var success:Bool
    var message:String

    //MARK: Initialization
    init(success:Bool,message:String){
        self.success = success
        self.message = message

    }
}
