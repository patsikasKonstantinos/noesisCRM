//
//  File.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 16/10/22.
//

import Foundation
import RealmSwift

class Payments:Economics{
    
    //MARK: Properties
    @Persisted var isIncome:Bool
    @Persisted var isExpenses:Bool
    @Persisted var price:Float
    @Persisted var projects:List<Projects>

    //MARK: Initialization
    convenience init(title:String,customers:List<Contacts>,comments:String,date:Date,isIncome:Bool,isExpenses:Bool,price:Float,projects:List<Projects>){
        self.init()
        self.title = title
        self.customers = customers
        self.comments = comments
        self.date = date
        self.isIncome = isIncome
        self.isExpenses = isExpenses
        self.price = price
        self.projects = projects
    }
}
 
