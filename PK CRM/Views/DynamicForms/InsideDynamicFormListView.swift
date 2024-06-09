//
//  InsideDynamicFormListView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 24/4/23.
//

import SwiftUI

struct InsideDynamicFormListView: View {
 
    //MARK: Variables
    @ObservedObject var viewModel: InsideDynamicFormListViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    //MARK: Initialization
    init(viewModel: InsideDynamicFormListViewModel) {
        self.viewModel = viewModel
    }
    
    //MARK: Body
    var body: some View {
        VStack {
            
            if(viewModel.filteredInsideDynamicFormEntries.count>0){
                List{
                    ForEach(Array(viewModel.filteredInsideDynamicFormEntries.enumerated()), id: \.1.id) { index, entry in
  
                        if !entry.isInvalidated {
                            ZStack{
                                NavigationLink{
                                    InsideDynamicFormView(viewModel: InsideDynamicFormViewModel(formId: viewModel.formId!, formination: viewModel.dynamicFormsFunctionality.convertFieldsListToArray(entry.fields), newEntry: false,entryId:entry.id))
                                } label: {
                                    InsideDynamicFormListViewItems(itemText: viewModel.getItemText(for: entry))
                                }
                            }
                        }
                    }
                    .onDelete(perform:viewModel.deleteDynamicForm)
                }
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .scrollContentBackground(.hidden)
                .sheet(isPresented: $viewModel.editExistedFormSheet,onDismiss:{
                    viewModel.dynamicFormID = nil
                }) {}
                .scrollContentBackground(.hidden)
            }
            else{
                HStack{
                    Spacer()
                    
                    Text("Entry Not Found")
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity,maxHeight: .infinity)
            }
        }
        .navigationBarLeadingViewModifier(withTitle: "\(viewModel.formName())", withColor: settingsViewModel.appAppearance)
        .frame(maxWidth: .infinity)
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
        .navigationBarItems(trailing:
             HStack{
                Spacer()
            
                NavigationLink{
                    InsideDynamicFormView(viewModel: InsideDynamicFormViewModel(formId: viewModel.formId!, formination: viewModel.dynamicFormsFields, newEntry:true, entryId: nil))
                } label: {
                    Text("Add")
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                }
            }
            .padding(.vertical,10)
        )
        .background(settingsViewModel.appAppearance.themeBackgroundColor)
    }
}
