//
//  ProjectsListView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 31/12/22.
//

import SwiftUI
 
struct ProjectsListView: View {
    
    //MARK: Variables
    @ObservedObject var viewModel: ProjectsListViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @State var deleteProject:Bool = false
    @State private var orientation = UIDeviceOrientation.unknown
    @State var columns: [GridItem] = []
 
    //MARK: Initialization
    init(viewModel: ProjectsListViewModel) {
         self.viewModel = viewModel
    }

    //MARK: Body
    var body: some View {
        NavigationStack {
            VStack {
                
                if viewModel.projects.count > 0 {
                    List {
                        LazyVGrid(columns: columns) {
                            ForEach(0..<viewModel.filteredProjects.count, id: \.self) {
                                index in
                                
                                ZStack {
                                    GradientBackgroundView(color: settingsViewModel.findProjectStatusColor(viewModel.filteredProjects[index].status).swiftUIColor, points: (startPoint:.top,endPoint:.bottom))
                                    
                                    ProjectsListViewItem(project: viewModel.filteredProjects[index])
                                         .homePageProjects(width: 250)
                                }
                                .onTapGesture {
                                    viewModel.editExistedProjectSheet = true
                                    viewModel.projectID = viewModel.filteredProjects[index].id
                                }
                             }
                        }
                        .listRowBackground(Color.black.opacity(0))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .sheet(isPresented: $viewModel.editExistedProjectSheet, onDismiss:{}){
                            ProjectView(viewModel: ProjectViewModel(newProject: false, projectId:viewModel.projectID))
                        }
                    }
                    .scrollContentBackground(.hidden)
                } else {
                    HStack {
                        Spacer()
                        
                        Text("Projects Not Found")
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
            .toolbar {
                ToolbarItem(placement: .principal) {
                    ProjectsListViewFilters()
                        .background(settingsViewModel.appAppearance.themeBackgroundColor)
                }
            }
            .navigationBarLeadingViewModifier(
                withTitle: "Projects", withColor: settingsViewModel.appAppearance
            )
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:
                HStack {
                    Text("Add")
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                        .onTapGesture {
                            viewModel.showingAddNewProjectSheet.toggle()
                        }
                        .sheet(isPresented:$viewModel.showingAddNewProjectSheet,onDismiss:{}){
                            ProjectView(viewModel: ProjectViewModel(newProject: true, projectId:viewModel.projectID))
                        }
                        .scrollContentBackground(.hidden)
                }
                .padding(.vertical, 10)
            )
            .background(settingsViewModel.appAppearance.themeBackgroundColor)
            .onAppear {
                viewModel.listCount = viewModel.allProjects.count
                viewModel.dataLoaded = true
                updateColumns()
            }
            .onRotate { newOrientation in
                orientation = newOrientation
                DispatchQueue.main.async {
                    updateColumns()
                }
             }
        }
    }
    
    private func updateColumns() {
        let screenWidth = UIScreen.main.bounds.width
        let itemCountPerRow = screenWidth < 700 ? 1 :
        UIDevice.current.userInterfaceIdiom == .pad ? Int(screenWidth / 260) : 2
        columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: itemCountPerRow)
     }
}
