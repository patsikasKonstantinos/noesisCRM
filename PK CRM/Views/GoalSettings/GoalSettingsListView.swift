//
//  GoalSettingsListView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 31/12/22.
//

import SwiftUI
 
struct GoalSettingsListView: View {
    
    //MARK: Variables
    @ObservedObject private var viewModel: GoalSettingsListViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    //MARK: Initialization
    init(viewModel: GoalSettingsListViewModel) {
        self.viewModel = viewModel
    }
    
    //MARK: Body
    var body: some View {
        VStack {
            
            if  viewModel.filteredGoalSettings.count > 0 {
                List {
                    ForEach(Array(viewModel.filteredGoalSettings.enumerated()), id: \.1.id) { index, goalSetting in
                        ZStack{
                            NavigationLink{
                                GoalSettingsView(
                                    viewModel: GoalSettingsViewModel(
                                        newGoalSettings: false, goalSettingsId:goalSetting.id
                                    )
                                )
                            } label: {
                                Text(goalSetting.title)
                                    .foregroundColor(Color.black)
                            }
                        }
                    }
                    .onDelete(perform: viewModel.deleteGoalSetting)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scrollContentBackground(.hidden)
            }
            else {
                HStack {
                    Spacer()
                    
                    Text("GoalSettings Not Found")
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
        .navigationBarLeadingViewModifier(withTitle: "GoalSettings", withColor: settingsViewModel.appAppearance)
        .navigationBarItems(trailing:
            HStack {
                Spacer()
            
                NavigationLink{
                    GoalSettingsView(
                        viewModel: GoalSettingsViewModel(
                            newGoalSettings: true, goalSettingsId:viewModel.goalSettingsID
                        )
                    )
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

 
 
 
