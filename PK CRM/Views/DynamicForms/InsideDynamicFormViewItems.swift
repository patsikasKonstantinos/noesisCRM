//
//  InsideDynamicFormViewItems.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 20/6/23.
//

import SwiftUI

extension InsideDynamicFormView {
    
    func InsideDynamicFormViewItems() -> some View {
        
        ForEach(0..<viewModel.formination.count,id: \.self) { index in
            HStack{
                Text("\(viewModel.formination[index].name):")
                    .foregroundColor(Color.black.opacity(0.6))
                    .font(.system(size: 16))
                
                //Except Contacts And Tasks
                if viewModel.formination[index].type != 6,
                   viewModel.formination[index].type != 7,
                   viewModel.formination[index].type != 10 {
                    let validIndices = viewModel.inputController.indices
                    if validIndices.contains(index) {
                        
                        if(viewModel.formination[index].type == 1){
                            TextField(
                                "",
                                text: Binding(
                                    get: { viewModel.inputController[index] as? String ?? "" },
                                    set: { viewModel.inputController[index] = $0 }
                                ),
                                onEditingChanged: { (isBegin) in }
                            )
                        }
                        else if viewModel.formination[index].type == 2 {
                            Toggle("", isOn: Binding(
                                get: { viewModel.inputController[index] as? Bool ?? false },
                                set: { viewModel.inputController[index] = $0 }
                            )) // 2
                        }
                        else if viewModel.formination[index].type == 9 {
                            NumberTextField(
                                text: Binding(
                                    get: {viewModel.inputController[index] as? String ?? "" },
                                    set: {viewModel.inputController[index] = $0 }
                                )
                            )
                        }
                        else if viewModel.formination[index].type == 4 {
                            TextField("",
                                text: Binding(
                                    get: {viewModel.inputController[index] as? String ?? "" },
                                    set: {viewModel.inputController[index] = $0.filter{"0123456789".contains($0)}}
                                )
                            )
                        }
                        //Date Picket
                        else if viewModel.formination[index].type == 5 {
                            // Date
                            DatePicker("",
                                selection: Binding(
                                    get: {viewModel.inputController[index] as? Date ?? Date() },
                                    set: {viewModel.inputController[index] = $0 }
                                ),
                                displayedComponents: [.date])
                                .padding(.top,5)
                                .padding(.bottom,5)
                        }
                        //Textarea
                        else if viewModel.formination[index].type == 8 {
                            TextField(
                                "",
                                text: Binding(
                                    get: {viewModel.inputController[index] as? String ?? "" },
                                    set: {viewModel.inputController[index] = $0}
                                ),
                                axis: .vertical
                            )
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.leading)
                            .padding(10)
                            .background(Color.black.opacity(0.02))
                            .cornerRadius(15)
                        }
                        //Countries
                        else if viewModel.formination[index].type == 3 {
                            
                            if let inputValue = viewModel.inputController[index] as? Int {
                                Picker(
                                    selection: Binding(
                                        get: {inputValue},
                                        set: {viewModel.inputController[index] = $0 }
                                    ),label: Text("")
                                ) {
                                    ForEach(0..<viewModel.country.count, id: \.self) { countriesCount in
                                        Text("\(viewModel.country[countriesCount]!)").tag(countriesCount)
                                    }
                                }
                            }
                        }
                    }
                }
                else{
                    //Select Another Table Tasks
                    let validIndices = viewModel.inputController.indices
                    if validIndices.contains(index) {
                        //Select Another Table Tasks
                        if viewModel.formination[index].type == 7 {
                            if let tasksController = viewModel.inputController[index] as? [Tasks] {
                                insideDynamicFormViewTasks(tasksController,index)
                            }
                        }
                        //Select Another Table Customers
                        else if viewModel.formination[index].type == 6 {
                            insideDynamicFormViewContacts(index)
                        }
                        else if viewModel.formination[index].type == 10 {
                            insideDynamicFormViewProjects(index)
                         }
                    }
                }
            }
        }
    }
}
