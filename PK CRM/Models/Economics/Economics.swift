//
//  Economics.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 6/3/23.
//

import Foundation
 
import RealmSwift

class Economics:Object , ObjectKeyIdentifiable {
    
    //MARK: Properties
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title:String
    @Persisted var customers:List<Contacts>
    @Persisted var incomeSum:Float
    @Persisted var expensesSum:Float
    @Persisted var incomeExpensesDiff:Float
    @Persisted var comments:String
    @Persisted var date:Date
 
    //MARK: Initialization
    convenience init(
        title:String,customers:List<Contacts>,incomeSum:Float,expensesSum:Float,
                     incomeExpensesDiff:Float,comments:String,date:Date){
        self.init()
        self.title = title
        self.customers = customers
        self.incomeSum = incomeSum
        self.expensesSum = expensesSum
        self.incomeExpensesDiff = incomeExpensesDiff
        self.comments = comments
        self.date = date
    }
}
