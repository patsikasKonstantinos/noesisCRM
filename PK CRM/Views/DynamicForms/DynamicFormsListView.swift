//
//  DynamicFormsListView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 31/12/22.
//

import SwiftUI

struct DynamicFormsListView: View {
    
    //MARK: Variables
    @ObservedObject private var viewModel: DynamicFormsListViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    //MARK: Initialization
    init(viewModel: DynamicFormsListViewModel) {
        self.viewModel = viewModel
    }
    
    //MARK: Body
    var body: some View {
        VStack {
            if viewModel.filteredDynamicForms.count > 0 {
                List {
                    //ForEach(viewModel.filteredDynamicForms, id: \.self) { dynamicForm in
                    ForEach(Array(viewModel.filteredDynamicForms.enumerated()), id: \.1.id) { index, dynamicForm in

                        ZStack{
                            NavigationLink{
                                InsideDynamicFormListView(viewModel: InsideDynamicFormListViewModel(formId: dynamicForm.id))
                            } label: {
                                Text("\(dynamicForm.name)")
                                    .foregroundColor(Color.black)
                            }
                        }
                    }
                    .onDelete(perform: viewModel.deleteDynamicForm)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scrollContentBackground(.hidden)
            } else {
                HStack {
                    Spacer()
                    
                    Text("Collections Not Found")
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
        .navigationBarLeadingViewModifier(withTitle: "Collections", withColor: settingsViewModel.appAppearance)
        .navigationBarItems(trailing:
            HStack {
                Spacer()
            
                NavigationLink{
                    AddNewDynamicFormView(viewModel: AddNewDynamicFormViewModel())
                } label: {
                    Text("Add")
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                }
            }
            .padding(.vertical, 10)
        )
        .background(settingsViewModel.appAppearance.themeBackgroundColor)
    }
}
