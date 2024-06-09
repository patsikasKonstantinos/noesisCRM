//
//  PaymentFunctionality.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 16/10/22.
//

import Foundation
import RealmSwift
 
class PaymentsFunctionality {
    
    //MARK: Properties
    let realm = RealmManager.shared.realm
    let contactsFunctionalityObj = ContactsFunctionality()
    let projectssFunctionalityObj = ProjectsFunctionality()
    let dateFormatter = DateFormatter()
    
    //MARK: Functions
    func convertPaymentsArrayToList(_ array:[Payments]) -> List<Payments> {
        let list = List<Payments>()
        list.append(objectsIn: array)
        return list
    }
    
    func convertPaymentDateFormat(date:Date) -> String {
        dateFormatter.dateFormat = "dd MMM, yyyy"
        let formatedDate = dateFormatter.string(from: date)
        return formatedDate
    }
    
    //Create a new Payment
    func createNewPayment(_ payment:Payments,_ customerView:Bool){
        let paymentObj = Payments(
            title: payment.title,
            customers:!customerView && payment.customers.count > 0 && contactsFunctionalityObj.findContacts(payment.customers[0].id).count  == 0 ?
            List<Contacts>() : payment.customers,
            comments: payment.comments,
            date: payment.date,
            isIncome: payment.isIncome,
            isExpenses: payment.isExpenses,
            price:  payment.price,
            projects: payment.projects
        )
        
        if customerView {
            paymentObj.id = payment.id
        }
 
        try! realm.write {
            realm.create(Payments.self, value: paymentObj, update: .modified)
        }
    }
    
    //Find Contact From Specific Sercg
    func findPayments(searchText search:String,_ payment:Payments) -> Bool {
        var returnValue:Bool = false
        let searchWords = search.split(separator: " ")
        for word in searchWords {
            if  payment.title.contains(word) {
                returnValue = true
            }
        }
        return returnValue
    }
    
    //Return Specific Payment Id
    func findPayments(_ paymentId:ObjectId) -> Results<Payments>  {
        let allPaymentsObj = realm.objects(Payments.self)
        let paymentFound = allPaymentsObj.where {
            $0.id == paymentId
        }
        return paymentFound
    }
    
    //Delete Payment
    func deletePayment(_ paymentId:ObjectId){
        let allPaymentsObj = realm.objects(Payments.self)
        let paymentDelete = allPaymentsObj.where {
            $0.id == paymentId
        }
        try! realm.write {
            realm.delete(paymentDelete)
        }
    }
    
    func deletePaymentFromSpecificContact(_ contactId:ObjectId, _ exceptPayments:[Payments]){
        let allPaymentsObj = realm.objects(Payments.self)
        let allPaymentsArray = Array(allPaymentsObj)
        let paymentDelete = allPaymentsArray.filter { payment in
            return payment.customers.contains { contact in
                return contact.id == contactId
            } && !exceptPayments.contains { $0.id == payment.id }
        }
        try! realm.write {
            realm.delete(paymentDelete)
        }
    }
    
    //Update current Contacts
    func savePayments(_ payment:Payments,_ paymentId:ObjectId) {
        let updatedObject = Payments(
            title:payment.title,
            customers:payment.customers,
            comments :payment.comments,
            date:payment.date,
            isIncome:payment.isIncome,
            isExpenses:payment.isExpenses,
            price:payment.price,
            projects:payment.projects
        )
        updatedObject.id = paymentId
        try! realm.write {
             realm.create(Payments.self, value: updatedObject, update: .modified)
        }
    }
    
    func getPaymentsPerMonth(_ paymentsList:[Payments],_ customers:[Contacts]?)->[EconomicsKind:[Int:Double]] {
        var filtered = paymentsList
        let calendar = Calendar.current
        
        //Initialize amounts
        var monthsAmount:[EconomicsKind:[Int:Double]] = [:]
        
        //Init
        monthsAmount[.incomes] = [:]
        monthsAmount[.expenses] = [:]
        
        //Incomes
        for i in 1...12 {
            monthsAmount[.incomes]![i] = 0.0
        }
        
        //Expenses
        for i in 1...12 {
            monthsAmount[.expenses]![i] = 0.0
        }

        // Filter the paymentsList based on the customers
        if let filteredCustomers = customers {
            if filteredCustomers.count > 0 {
                let filteredPayments = paymentsList.filter { payment in
                    payment.customers.contains { customer in
                        filteredCustomers.contains { conditionCustomer in
                            customer.id == conditionCustomer.id
                        }
                    }
                }
                filtered = filteredPayments
            }
        }
        
        for payment in filtered {
            let monthComponent = calendar.component(.month, from: payment.date)
            if let incomeAmount = monthsAmount[.incomes]?[monthComponent] {
                if payment.isIncome {
                    monthsAmount[.incomes]![monthComponent] = incomeAmount + Double(payment.price)
                }
            }
            if let expenseAmount = monthsAmount[.expenses]?[monthComponent] {
                if payment.isExpenses {
                    monthsAmount[.expenses]![monthComponent] = expenseAmount + Double(payment.price)
                }
            }
        }
        return monthsAmount
    }
    
    func findContactPaymentsSums(_ paymentsList:[Payments]) -> [Int:String] {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ""
        var sums:[Int:String] = [0:"0.0",1:"0.0",2:"0.0",3:"zero"]
        let filteredListIncome = paymentsList.filter { $0.isIncome == true && $0.isExpenses == false} // filter objects with even value
        let filteredListExpenses = paymentsList.filter {$0.isIncome == false && $0.isExpenses == true} // filter objects with even value
        var income = Float(filteredListIncome.reduce(0) { $0 + $1.price })
        var expenses = Float(filteredListExpenses.reduce(0) { $0 + $1.price })

        if let formattedIncomeString = formatter.string(from: NSNumber(value: income)),
           let formattedIncome = Float(formattedIncomeString) {
            income = formattedIncome
         }
 
        if let formattedExpensesString = formatter.string(from: NSNumber(value: expenses)),
           let formattedExpenses = Float(formattedExpensesString) {
            expenses = formattedExpenses
             

        }
        sums[0] = "\(income)"
        sums[1] = "\(expenses)"
        sums[2] = "\(income - expenses)"
        sums[3] = income - expenses > 0 ? "positive" : income - expenses == 0 ? "zero" : "negative"
        return sums
    }
}
