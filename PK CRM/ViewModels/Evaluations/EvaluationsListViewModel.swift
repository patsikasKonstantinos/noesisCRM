//
//  EvaluationsListViewModel.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 16/6/23.
//

import Foundation
import RealmSwift

class EvaluationsListViewModel: ObservableObject {
    @ObservedResults(Evaluations.self) var allEvaluations
    
    //MARK: Published Properties
    @Published var shouldUpdateList:Bool = false
    @Published var selectedEvaluation = 0
    @Published var showingAddNewEvaluationSheet = false
    @Published var editExistedEvaluationSheet = false
    @Published var evaluationID: ObjectId?
    @Published var searchText = ""
    @Published var listCount:Int = 0
    @Published var addNewEntry = false
    
    //MARK: let Properties
    private let evaluationsFunctionality: EvaluationsFunctionality
    
    //MARK: var Properties
    private var notificationToken:NotificationToken?
    
    var evaluations: [Evaluations] {
        return Array(allEvaluations.sorted(byKeyPath: "endDate", ascending: false))
    }
    var filteredEvaluations: [Evaluations] {
        if searchText.isEmpty {
            return evaluations
        } else {
            return evaluations.filter { evaluation in
                evaluationsFunctionality.findEvaluations(searchText: searchText, evaluation)
            }
        }
    }
    
    //MARK: Initialization
    init(evaluationsFunctionality: EvaluationsFunctionality) {
        self.evaluationsFunctionality = evaluationsFunctionality
        notificationToken = RealmManager.shared.realm.observe { [weak self] (_ ,_)  in
            self?.objectWillChange.send()
        }
    }
    
    deinit {
        // Invalidate the token when the object is deallocated
        notificationToken?.invalidate()
    }
     
    //MARK: Functions
    func updateListId(){
        shouldUpdateList.toggle()
        listCount = allEvaluations.count
    }
    
    func changeDateFormat(date: Date) -> String {
        return evaluationsFunctionality.changeDateFormat(date: date)
    }
    
    func deleteEvaluation(offsets: IndexSet) {
        let index = offsets[offsets.startIndex]
        let evaluationId = evaluations[index].id
        evaluationsFunctionality.deleteEvaluations(evaluationId)
        updateListId()
    }
}
