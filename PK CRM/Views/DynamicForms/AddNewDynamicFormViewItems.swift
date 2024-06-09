//
//  AddNewDynamicFormViewItems.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 19/6/23.

import SwiftUI

// MARK: Main list items
extension AddNewDynamicFormView{
    
    func listItems() -> some View {
        
        return  ForEach (viewModel.fields, id: \.self ){ field in
            
            if !viewModel.fieldsController.removed[field.position-1]  {
                VStack{
                    HStack{
                        Text("Field Name")
                            .foregroundColor(viewModel.filledFieldName[field.position-1] ? Color.black.opacity(0.6) : Color.red)
                            .font(.system(size: 16))
                            .frame(alignment:.leading)
                        
                        TextField(
                            "",
                            text: $viewModel.fieldsController.name[field.position-1],
                            onEditingChanged: { (isBegin) in
                                //Change Required Fields Colors
                                if isBegin {
                                    viewModel.filledFieldName[field.position-1] = true
                                }
                            }
                        )
                    }
                    
                    Picker(selection: $viewModel.fieldsController.type[field.position-1],
                           label: Text("Τype")
                        .foregroundColor(Color.black.opacity(0.6))
                        .font(.system(size: 16))
                        .frame(alignment:.leading)){
                        ForEach(viewModel.dynamicFormsFieldsTypes,id: \.kind) { field in
                            
                            HStack{
                                if let image = viewModel.dynamicFormsFieldsTypesImages[field.kind] {
                                    Image(systemName: "\(image)")
                                }
                                Text("\(field.name)")
                            }.tag(field.kind)
                        }
                    }
        
                    //If field is Status Or Toggle dont display
                    if viewModel.fieldsController.type[field.position-1] != 2 , viewModel.fieldsController.type[field.position-1] != 3
                        , viewModel.fieldsController.type[field.position-1] != 5 {
                        Toggle("Required", isOn: $viewModel.fieldsController.required[field.position-1]) // 2
                            .foregroundColor(Color.black.opacity(0.6))
                            .font(.system(size: 16))
                    }
                }
            }
            else{
                EmptyView()
            }
        }
        .onDelete(perform:viewModel.deleteField)
    }
}
