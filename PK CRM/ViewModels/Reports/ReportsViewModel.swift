//
//  ReportsViewModel.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 27/7/23.
//

import Foundation
import RealmSwift

class ReportsViewModel: ObservableObject {
    @ObservedResults(Payments.self) var allPayments
    @ObservedResults(Evaluations.self) var allEvaluations
    
    //MARK: Published Properties
    @Published var filterStartDate: Date =  Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @Published var filterFinishDate: Date = Date()
    @Published var filterSumEvaluation:Int = 0
    @Published var sortEvaluations:Int = 0
    @Published var showFilters:Bool = false
    @Published var selectedContacts: [Contacts] = []
    @Published var shouldUpdateList:Bool = false
    @Published var evaluationsCategoriesArr:[EvaluationsCategories] = []
    @Published var fromNavigation = false
    @Published var economicsCustomersFilter: [Contacts] = []
    @Published var economicsKindFilter:Int = 0
    
    //MARK: let Properties
    private let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    private let calendar = Calendar.current
    private let paymentsFunctionality: PaymentsFunctionality = PaymentsFunctionality()
    private let evaluationsFunctionality: EvaluationsFunctionality = EvaluationsFunctionality()
    private let reportsFunctionality: ReportsFunctionality = ReportsFunctionality()
    
    //MARK: var Properties
    private var startOfDay: Date {
        return calendar.date(bySettingHour: 00, minute: 00, second: 00, of: filterStartDate) ?? filterStartDate
    }
    private var endOfDay: Date {
        return calendar.date(bySettingHour: 23, minute: 59, second: 59, of: filterFinishDate) ?? filterFinishDate
    }
    var sortBy = "endDate"
    var ascending = false
    private var incomes: [EconomicsChartDataPoint] = {
        var initIncomes: [EconomicsChartDataPoint] = [
            .init(month: "Jan", amount: 0.00),
            .init(month: "Feb", amount: 0.00),
            .init(month: "Mar", amount: 0.00),
            .init(month: "Apr", amount: 0.00),
            .init(month: "May", amount: 0.00),
            .init(month: "Jun", amount: 0.00),
            .init(month: "Jul", amount: 0.00),
            .init(month: "Aug", amount: 0.00),
            .init(month: "Sep", amount: 0.00),
            .init(month: "Oct", amount: 0.00),
            .init(month: "Nov", amount: 0.00),
            .init(month: "Dec", amount: 0.00)
        ]
        return initIncomes
    }()
    
    private var expenses: [EconomicsChartDataPoint] = {
        var initExpenses: [EconomicsChartDataPoint] = [
            .init(month: "Jan", amount: 0.00),
            .init(month: "Feb", amount: 0.00),
            .init(month: "Mar", amount: 0.00),
            .init(month: "Apr", amount: 0.00),
            .init(month: "May", amount: 0.00),
            .init(month: "Jun", amount: 0.00),
            .init(month: "Jul", amount: 0.00),
            .init(month: "Aug", amount: 0.00),
            .init(month: "Sep", amount: 0.00),
            .init(month: "Oct", amount: 0.00),
            .init(month: "Nov", amount: 0.00),
            .init(month: "Dec", amount: 0.00)
        ]
        return initExpenses
    }()
    
    var sortingΕvaluationsArray:[ObjectId:Float]   {
        return evaluationsFunctionality.sortingΕvaluationsArray(evaluations: Array(allEvaluations.filter("startDate >= %@ AND endDate <= %@", startOfDay,endOfDay)))
    }
    
    lazy var selectContactsViewModel: SelectContactsViewModel = {
           return SelectContactsViewModel(multiple: true, contactType: 3,selected: selectedContacts)
    }()
    
    lazy var currentYear:Int = {
        
        return reportsFunctionality.getCurrentYear()
    }()
    
    lazy var economicsFilterYear:Int = {
        
        return reportsFunctionality.getCurrentYear()
    }()
 
    //MARK: Functions
    func evaluationSort() {
        if sortEvaluations == 0 {
            sortBy = "startDate"
            ascending = true
        }
        else if sortEvaluations == 1 {
            sortBy = "startDate"
            ascending = false
        }
        else if sortEvaluations == 2 {
            sortBy = "endDate"
            ascending = true
        }
        else if sortEvaluations == 3 {
            sortBy = "endDate"
            ascending = false
        }
    }
    
    func formatYearFilterToString(_ year: Int) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .none
            return formatter.string(for: year) ?? ""
    }
    
    func submitEvaluationFilter(_ filterStartDate:Date, _ filterFinishDate:Date, _ sortEvaluations:Int, _ filterSumEvaluation:Int){
        self.filterStartDate = filterStartDate
        self.filterFinishDate = filterFinishDate
        self.sortEvaluations = sortEvaluations
        self.filterSumEvaluation = filterSumEvaluation
        showFilters = false
    }
    
    func submitEconomicsFilter(_ economicsKindFilter:Int,_ economicsFilterYear:Int, _ economicsCustomersFilter:[Contacts]){
        self.economicsKindFilter = economicsKindFilter
        self.economicsFilterYear = economicsFilterYear
        self.economicsCustomersFilter = economicsCustomersFilter
        showFilters = false
    }
 
    func resetEvaluationFilters() -> (Date, Date, Int,Int) {
        let reset = (previousMonth,Date(),0,0)
        return reset
    }
    
    func resetEconomicsFilters() -> (Int,Int,[Any]) {
        let reset = (currentYear,0,[])
        return reset
    }
    
    var payments: [EconomicsKind:[EconomicsChartDataPoint]] {
        var paymentsArr:[EconomicsKind:[Int:Double]] = [:]
        let dates = reportsFunctionality.getFirstAndLastYearDay(economicsFilterYear)
        let filteredDatePayments = Array(
            allPayments.filter("date >= %@ AND date <= %@", dates[0],dates[1])
        )
        paymentsArr = paymentsFunctionality.getPaymentsPerMonth(filteredDatePayments,economicsCustomersFilter)

        //Incomes
        for payment in paymentsArr[.incomes]!{
            incomes[payment.key-1] = EconomicsChartDataPoint(month: Variables.months[payment.key]!, amount: payment.value)
        }
 
        //Expenses
        for payment in paymentsArr[.expenses]!{
            expenses[payment.key-1] = EconomicsChartDataPoint(month: Variables.months[payment.key]!, amount: payment.value)
        }

        return [.incomes:incomes,.expenses:expenses]
    }
    
    var evaluations: [Evaluations] {
        var returnArray:[Evaluations] = []
        evaluationSort()
        
        //DATE
        if sortEvaluations <= 3 {
            returnArray = Array(
                allEvaluations.filter("startDate >= %@ AND endDate <= %@", startOfDay,endOfDay)
                    .sorted(byKeyPath: sortBy, ascending: ascending)
            )
        }
        
        //EMPLOYEE EVALUATION
        else{
            returnArray = evaluationsFunctionality.getSortedEvaluations(evaluations: Array(allEvaluations.filter("startDate >= %@ AND endDate <= %@", startOfDay,endOfDay)),sortEvaluations:sortEvaluations,sortingArray:sortingΕvaluationsArray)
        }
        returnArray = evaluationsFunctionality.filterScore(evaluations:returnArray,filterSumEvaluation:filterSumEvaluation,sortingArray: sortingΕvaluationsArray)
        return returnArray
    }
}
