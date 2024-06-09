//
//  Contacts.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 1/1/23.
//

import Foundation
import RealmSwift

class Contacts: Object , ObjectKeyIdentifiable {
    
    //MARK: Properties
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var type:Int = 0
    @Persisted var firstName:String = ""
    @Persisted var surnName:String = ""
    @Persisted var telephoneNumber:String = ""
    @Persisted var mobilePhoneNumber:String = ""
    @Persisted var country:Int = 0
    @Persisted var state:String = ""
    @Persisted var city:String = ""
    @Persisted var address:String = ""
    @Persisted var postCode:String = ""
    @Persisted var taxId:String = ""
    @Persisted var identityId:String = ""
    @Persisted var active:Bool = false
    
    //MARK: Initialization
    convenience init(type:Int,firstName:String,surnName:String,telephoneNumber:String,
         mobilePhoneNumber:String,country:Int,state:String,city:String,address:String,
                     postCode:String,taxId:String,identityId:String,active:Bool){
        self.init()
        self.type = type
        self.firstName = firstName
        self.surnName = surnName
        self.telephoneNumber = telephoneNumber
        self.mobilePhoneNumber = mobilePhoneNumber
        self.country = country
        self.state = state
        self.city = city
        self.address = address
        self.postCode = postCode
        self.taxId =  taxId
        self.identityId = identityId
        self.active = active
    }
}
