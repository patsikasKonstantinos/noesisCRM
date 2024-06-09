//
//  EvaluationViewModel.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 18/6/23.
//

import Foundation
import RealmSwift
import Combine

class EvaluationViewModel: ObservableObject {
    @ObservedResults(EvaluationsCategories.self) var evaluationsCategories
    
    //MARK: Published Properties
    @Published var newEvaluations:Bool
    @Published var evaluations:Results<Evaluations>?
    @Published var selectedUsers: [Contacts] = []
    @Published var showingAlert = false
    @Published var fromNavigation = false
    @Published var alertTitle = "Success,"
    @Published var alertText = "Your DaysOff Saved Successfully"
    @Published var title:String = ""
    @Published var filledTitle:Bool = true
    @Published var filledUser:Bool = true
    @Published var inputController:[Any] = []
    
    @Published var evaluationStars: [Int] = {
        var stars = Array(repeating: 0, count: Variables.evaluationCategories.count)
        for category in Variables.evaluationCategories {
            stars[category.key] = 0
        }
        return stars
    }()
    
    @Published var sumEvaluationStars:Float = 0.0
    @Published var evaluationsCategoriesArr:[EvaluationsCategories] = []
    
    //MARK: let Properties
    private let dismissView = PassthroughSubject<Void, Never>()
    let evaluationsObj = EvaluationsFunctionality()
    let contactsObj = ContactsFunctionality()
    let evaluationsId:ObjectId?
    let listViewItems = Variables.evaluattionViewListItems
    let evaluationCategories =  Variables.evaluationCategories
    
    //MARK: var Properties
    private var firstLoad: Bool = true
    
    var dismissRequest: AnyPublisher<Void, Never> {
        dismissView.eraseToAnyPublisher()
    }
    lazy var selectUsersViewModel: SelectContactsViewModel = {
           return SelectContactsViewModel(multiple: false, contactType: 2,selected: selectedUsers)
    }()
 
    //MARK: Initialization
    init(newEvaluations: Bool, evaluationsId: ObjectId?) {
        self.newEvaluations = newEvaluations
        self.evaluationsId = evaluationsId
    }
    
    //MARK: Functions
    func saveEvaluation(){
        evaluationsCategoriesArr = []
        
        for i in 0..<evaluationStars.count {
            evaluationsCategoriesArr.append(EvaluationsCategories(category: i, categoryEvaluation: Float(evaluationStars[i])))
        }
        
        let currEvaluationDataObj = Evaluations(
            title: title,
            contact: contactsObj.convertContactsArrayToList(selectUsersViewModel.selected),
            startDate: inputController[2] as? Date ?? Date(),
            endDate: inputController[3] as? Date ?? Date(),
            date: inputController[4] as? Date ?? Date(),
            evaluationsCategories: evaluationsObj.convertEvaluationsCategoriesArrayToList(evaluationsCategoriesArr),
            comments: inputController[6] as? String ?? ""
        )

        if !selectUsersViewModel.selected.isEmpty
            && !title.isEmpty
            && inputController[3] as? Date ?? Date() >= inputController[2] as? Date ?? Date(){
            if newEvaluations {
                evaluationsObj.createNewEvaluations(currEvaluationDataObj)
            }
            else{
                evaluationsObj.saveEvaluations(currEvaluationDataObj,evaluationsId!)
            }
            dismissView.send()
        }
        else{
            alertTitle = "Oops,"
            if inputController[3] as? Date ?? Date() >= inputController[2] as? Date ?? Date(){
                 alertText = "Please fill out all required fields"
                
                if title.isEmpty{
                    filledTitle = false
                }
                else{
                    filledTitle = true
                }
                
                if !selectUsersViewModel.selected.isEmpty{
                    filledUser = true
                }
                else{
                    filledUser = false
                }

            }
            else{
                alertText = "Τhe start date must be before the finish date"
            }
            showingAlert = true
        }
    }
    
    func setStars(_ key:Int , _ index:Int){
        //Select Evaluation Stars
        if evaluationStars[key] == index {
            evaluationStars[key] = 0
        }else {
            evaluationStars[key] = index
        }
        sumEvaluationStars = 0
        for star in evaluationStars {
            sumEvaluationStars += Float(star)
        }
        sumEvaluationStars = sumEvaluationStars / Float(Variables.evaluationCategories.count)
    }
    
    func resetEvaluationStars(){
        for index in 0..<evaluationStars.count {
            evaluationStars[index] = 0
        }
    }
    
    func resetForm(){
        if newEvaluations{
            showingAlert = false
            filledUser = true
            filledTitle = true
            inputController = []
            resetEvaluationStars()
            selectUsersViewModel.selected = []
            evaluationsCategoriesArr = []
            title = ""
            sumEvaluationStars = 0.0
            setup()
        }
    }
    
    func setup(){
        if !fromNavigation {
            for index in 0..<listViewItems.count {
                if listViewItems[index]!.type == 1 ||
                    listViewItems[index]!.type == 4 ||
                    listViewItems[index]!.type == 8 ||
                    listViewItems[index]!.type == 9 ||
                    listViewItems[index]!.type == 12 {
                    inputController.append("")
                }
                else if listViewItems[index]!.type == 2 {
                    inputController.append(false)
                }
                else if listViewItems[index]!.type == 3 {
                    inputController.append(0)
                }
                else if listViewItems[index]!.type == 5 {
                    inputController.append(Date())
                }
                else if listViewItems[index]!.type == 6
                            || listViewItems[index]!.type == 7
                {
                    inputController.append([])
                }
            }
            
            if !newEvaluations {
                evaluations = evaluationsObj.findEvaluations(evaluationsId!)
                title = evaluations![0].title
                selectUsersViewModel.selected = contactsObj.convertContactsListToArray(evaluations![0].contact)
                inputController[2] = evaluations![0].startDate
                inputController[3] = evaluations![0].endDate
                inputController[4] = evaluations![0].date
                inputController[6] = evaluations![0].comments
                evaluationsCategoriesArr = evaluationsObj.convertEvaluationsCategoriesListToArray(evaluations![0].evaluationsCategories)
                sumEvaluationStars = 0
                
                for evaluationItem in evaluationsCategoriesArr {
                    evaluationStars[evaluationItem.category] = Int(evaluationItem.categoryEvaluation)
                    sumEvaluationStars += Float(evaluationStars[evaluationItem.category])
                }
                
                sumEvaluationStars = sumEvaluationStars / Float(Variables.evaluationCategories.count)
            }
        }
    }
}
