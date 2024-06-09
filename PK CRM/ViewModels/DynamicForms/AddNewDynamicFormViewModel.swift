//
//  AddNewDynamicFormViewModel.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 19/6/23.
//

import Foundation
import RealmSwift
import Combine

class AddNewDynamicFormViewModel: ObservableObject {
    
    //MARK: Published Properties
    @Published var collectionNameController: String = ""
    @Published var fieldsController:(name:[String],type:[Int],required:[Bool],removed:[Bool]) = ([], [], [],[])
    @Published var showingAlert = false
    @Published var fields:[DynamicFormsFields] = []
    @Published var alertTitle = "Oops,"
    @Published var alertText = "Please fill out all name fields"
    @Published var filledName = true
    @Published var filledFieldName:[Bool] = []
    
    //MARK: let Properties
    private let dismissView = PassthroughSubject<Void, Never>()
    let dynamicFormsObj = DynamicFormsFunctionality()
    let dynamicFormsFieldsTypes = Variables.dynamicFormsFieldsTypes
    let dynamicFormsFieldsTypesImages = Variables.dynamicFormsFieldsTypesImages
    
    //MARK: var Properties
    var dismissRequest: AnyPublisher<Void, Never> {
        dismissView.eraseToAnyPublisher()
    }
    
    //MARK: Functions
    func addNewField(){
        filledFieldName.append(true)
        fieldsController.name.append("")
        fieldsController.type.append(1)
        fieldsController.required.append(false)
        fieldsController.removed.append(false)
        fields.append(
            DynamicFormsFields(
                name: "",
                type: 1,
                required:false,
                position: fields.count+1
            )
        )
    }
    
    func saveNewDynamicForm(){
        if fieldsController.name.count - fieldsController.name.indices.filter { fieldsController.removed[$0] }.count == 0 {
            alertTitle = "Oops,"
            alertText = "You must create at least one field"
            showingAlert = true
        }
        else{
            var emptyIndexes = fieldsController.name.indices.filter { fieldsController.name[$0] == "" && fieldsController.removed[$0] == false}
            if collectionNameController.isEmpty || emptyIndexes.count > 0 {
                if collectionNameController.isEmpty {
                    filledName = false
                }
                else {
                    filledName = true
                }
                
                for empty in emptyIndexes {
                    filledFieldName[empty] = false
                }
                alertTitle = "Oops,"
                alertText = "Please fill out all name fields"
                showingAlert = true
            }
            else{
                dynamicFormsObj.createNewCustomForm(collectionNameController,fieldsController){
                    success in
                    if success {
                        dismissView.send()
                    }
                }
            }
        }
    }
    
    func deleteField(offsets: IndexSet){
        let index = offsets[offsets.startIndex]
        fieldsController.removed[index] = true
    }
}
