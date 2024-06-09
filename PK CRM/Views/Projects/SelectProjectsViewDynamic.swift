//
//  SelectProjectsViewDynamic.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 31/12/22.
//

import SwiftUI

struct SelectProjectsViewDynamic: View {
    
    //MARK: Variables
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SelectProjectsViewModelDynamic
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @Binding var selectedProjects:[Int:[Projects]]
    @Binding var fromNavigation:Bool
    @State var showingAlertAnimation = false
    let index:Int
    
    //MARK: Initialization
    init(viewModel: SelectProjectsViewModelDynamic,selectedProjects:Binding<[Int: [Projects]]>,index:Int,fromNavigation:Binding<Bool>) {
        self.viewModel = viewModel
        _selectedProjects = selectedProjects
        self.index = index
        _fromNavigation = fromNavigation
    }

    //MARK: Body
    var body: some View {
        VStack {
           
            if(viewModel.projects.count>0){
                List{
                    ForEach(viewModel.filteredProjects){
                        project in
                            Button {
                               viewModel.selected = viewModel.selectProjectsAction(project)
                                selectedProjects[index] = viewModel.selected
                            } label: {
                                HStack {
                                    Text(project.code+", "+project.title)
                                        .foregroundColor(Color.black)
                                    
                                    Spacer()
                                    
                                    if viewModel.isSelected(project) {
                                        Image(systemName: "checkmark")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width:15,height:15)
                                            .padding(.leading,5)
                                             
                                    }else{
                                        Spacer()
                                            .frame(width:15,height:15)
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
        .onAppear{
            viewModel.setup(selectedProjects[index] ?? [])
            fromNavigation = true
        }
        .navigationBarLeadingViewModifier(withTitle: "Projects", withColor: settingsViewModel.appAppearance)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(viewModel.allProjects.count > 0 ? .visible : .hidden, for: .navigationBar)
        .toolbarBackground(.white, for: .navigationBar)
        .background(settingsViewModel.appAppearance.themeBackgroundColor)
    }
}

 
 
 
 
