//
//  SelectProjectsView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 31/12/22.
//

import SwiftUI
 
struct SelectProjectsView: View {
    
    //MARK: Variables
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SelectProjectsViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @Binding var fromNavigation:Bool
    @State var showingAlertAnimation = false
         
    //MARK: Initialization
    init(viewModel: SelectProjectsViewModel,fromNavigation:Binding<Bool>) {
        self.viewModel = viewModel
        _fromNavigation = fromNavigation
    }
    
    //MARK: Body
    var body: some View {
        VStack {
            
            if(viewModel.projects.count>0){
                List{
                    ForEach(viewModel.filteredProjects){ project in
                            Button {
                                 viewModel.selected = viewModel.selectProjectsAction(project)
                            }  label: {
                                HStack {
                                    Text(project.code+", "+project.title)
                                        .foregroundColor(Color.black)
                                    
                                    Spacer()
                                    
                                    if viewModel.isSelected(project) {
                                        Image(systemName: "checkmark")
                                            .padding(.leading,5)
                                    }
                                }
                            }
                    }
                    .listRowBackground(Color.white)
                }
                .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
                .scrollContentBackground(.hidden)
            }else{
                Spacer()
                
                Text("Projects Not Found")
                    .frame(maxWidth:.infinity)
                
                Spacer()
            }
        }
        .navigationBarLeadingViewModifier(
            withTitle: "Projects", withColor: settingsViewModel.appAppearance
        )
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(viewModel.allProjects.count > 0 ? .visible : .hidden, for: .navigationBar)
        .toolbarBackground(.white, for: .navigationBar)
        .background(settingsViewModel.appAppearance.themeBackgroundColor)
        .onAppear{
            fromNavigation = true
        }
    }
}
