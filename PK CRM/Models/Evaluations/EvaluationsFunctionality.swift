//
//  EvaluationsFunctionality.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 2/10/22.
//

import Foundation
import RealmSwift

class EvaluationsFunctionality:ObservableObject{
    
    //MARK: Properties
    let realm = RealmManager.shared.realm
    let contactsFunctionalityObj = ContactsFunctionality()
    let projectssFunctionalityObj = ProjectsFunctionality()
    let dateFormatter = DateFormatter()

    //MARK: Functions
    func getSortedEvaluations(evaluations: [Evaluations],sortEvaluations:Int,sortingArray:[ObjectId:Float]) -> [Evaluations] {
        let indexes = Array(0..<evaluations.count)
        // Sort the indexes based on the sortingArray using the sorted(by:) method
        let sortedIndexes = sortEvaluations == 4 ?
            indexes.sorted {
                i, j in
                sortingArray[evaluations[i].id] ?? 0 < sortingArray[evaluations[j].id] ?? 0
            } : indexes.sorted {
                i, j in
                sortingArray[evaluations[i].id] ?? 0 > sortingArray[evaluations[j].id] ?? 0
            }
        // Use the sorted indexes to get the sorted allEvaluations array
        let sortedAllEvaluations = sortedIndexes.map { evaluations[$0] }
        return sortedAllEvaluations
    }
    
    func filterScore(evaluations: [Evaluations],filterSumEvaluation:Int,sortingArray:[ObjectId:Float]) -> [Evaluations]{
        var returnArray:[Evaluations] = []
        
        for evaluation in evaluations {
            if sortingArray[evaluation.id] ?? 0.0 >= Float(filterSumEvaluation) {
                returnArray.append(evaluation)
            }
        }
        return returnArray
    }
    
    func sortingΕvaluationsArray(evaluations:[Evaluations]) -> [ObjectId:Float] {
        var array: [ObjectId:Float] = [:]
        
        for evaluation in evaluations {
            let currScore = sumEvaluation(evaluation: evaluation)
            array[evaluation.id] = currScore
        }
        return array
    }
    
    func sumEvaluation(evaluation: Evaluations) -> Float {
        var sumEvaluationStars:Float = 0.0
        
        for category in evaluation.evaluationsCategories {
            sumEvaluationStars += Float(category.categoryEvaluation)
        }
        sumEvaluationStars = Float(sumEvaluationStars) / Float(Variables.evaluationCategories.count)
        return sumEvaluationStars
    }
    
    func convertEvaluationsCategoriesArrayToList(_ array:[EvaluationsCategories]) -> List<EvaluationsCategories> {
         let list = List<EvaluationsCategories>()
         list.append(objectsIn: array)
         return list
    }
     
   
    func convertEvaluationsCategoriesListToArray(_ list:List<EvaluationsCategories>) -> [EvaluationsCategories] {
        var array:[EvaluationsCategories] = []
        array.append(contentsOf:list)
        return array
   }
    
    func convertEvaluationsArrayToList(_ array:[Evaluations]) -> List<Evaluations> {
         let list = List<Evaluations>()
         list.append(objectsIn: array)
         return list
    }
    
    //Return Evaluations
    func findEvaluations() -> Results<Evaluations> {
        let evaluations = realm.objects(Evaluations.self).sorted(byKeyPath: "firstName", ascending: true)
        return evaluations
    }
    
    //Return Specific Evaluation Id
    func findEvaluations(_ evaluationId:ObjectId) -> Results<Evaluations>  {
        let allEvaluationsObj = realm.objects(Evaluations.self)
        let evaluationFound = allEvaluationsObj.where {
            $0.id == evaluationId
        }
        return evaluationFound
    }
    
    //Return Specific Evaluation Id
    func findEvaluationsArrayFormat(_ evaluationId:ObjectId) -> [Evaluations]  {
        var list:[Evaluations] = []
        let allEvaluationsObj = realm.objects(Evaluations.self)
        let evaluationFound = allEvaluationsObj.where {
            $0.id == evaluationId
        }
        
        for evaluation in evaluationFound {
            list.append(evaluation)
        }
        return list
    }
    
    //Find Contact From Specific Search
    func findEvaluations(searchText search:String,_ evaluations:Evaluations) -> Bool {
        var returnValue:Bool = false
        let searchWords = search.split(separator: " ")
        
        for word in searchWords {
            if  evaluations.title.contains(word) {
                returnValue = true
            }
        }
        return returnValue
    }
    
    //Create a new Evaluations
    func createNewEvaluations(_ evaluation:Evaluations){
        let evaluationObj = Evaluations(
            title: evaluation.title,
            contact:evaluation.contact.count > 0 && contactsFunctionalityObj.findContacts(evaluation.contact[0].id).count  == 0 ?
            List<Contacts>() : evaluation.contact,
            startDate: evaluation.startDate,
            endDate: evaluation.endDate,
            date: evaluation.date,
            evaluationsCategories: evaluation.evaluationsCategories,
            comments: evaluation.comments
        )
        
        try! realm.write {
            realm.create(Evaluations.self, value: evaluationObj, update: .all)
       }
    }
    
    //Delete Evaluation
    func deleteEvaluations(_ evaluationId:ObjectId){
        let allEvaluationsObj = realm.objects(Evaluations.self)
        let evaluationDelete = allEvaluationsObj.where {
            $0.id == evaluationId
        }
        
        try! realm.write {
            realm.delete(evaluationDelete)
        }
    }
    
    //Update current Evaluations
    func saveEvaluations(_ evaluation:Evaluations,_ evaluationId:ObjectId) {
        if contactsFunctionalityObj.findContacts(evaluation.contact[0].id).count  == 0 {}
        let evaluationObj = Evaluations(
            title: evaluation.title,
            contact:evaluation.contact.count > 0 && contactsFunctionalityObj.findContacts(evaluation.contact[0].id).count  == 0 ?
            List<Contacts>() : evaluation.contact,
            startDate: evaluation.startDate,
            endDate: evaluation.endDate,
            date: evaluation.date,
            evaluationsCategories: evaluation.evaluationsCategories,
            comments: evaluation.comments
        )
        evaluationObj.id = evaluationId
 
        try! realm.write {
             realm.create(Evaluations.self, value: evaluationObj, update: .modified)
        }
    }

    func convertEvaluationContactsArrayToList(_ array:[Contacts]) -> List<Contacts> {
         let list = List<Contacts>()
         list.append(objectsIn: array)
         return list
    }
    
    func convertEvaluationContactsListToArray(_ list:List<Contacts>) -> [Contacts] {
         var array:[Contacts] = []
         array.append(contentsOf:list)
         return array
    }
    
    func changeDateFormat(date:Date) -> String {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
     }
}
