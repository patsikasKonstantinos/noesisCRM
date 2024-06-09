//
//  TasksListView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 31/12/22.
//

import SwiftUI
 
struct TasksListView: View {
    
    //MARK: Variables
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: TasksListViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @Binding var tasks:[Tasks]
    @Binding var navigationView:Bool
    @State var showNewTasksDetails:Bool = false
    @State var showEditTasksDetails:Bool = false
     
    //MARK: Initialization
    init(viewModel: TasksListViewModel,tasks: Binding<[Tasks]>,navigationView: Binding<Bool>){
         self.viewModel = viewModel
        _navigationView = navigationView
        _tasks = tasks
        //viewModel.setup(_tasks.wrappedValue)
    }

    //MARK: Body
    var body: some View {
        VStack {
            
            if tasks.count > 0 {
                List {
                    ForEach(0..<tasks.count, id: \.self) { index in
                        if viewModel.filteredTasks(tasks[index]) {
                            Button(!tasks[index].code.isEmpty ? tasks[index].code + ", " + tasks[index].title : tasks[index].title){
                                viewModel.taskViewModel.newTask = false
                                viewModel.taskViewModel.selectedTaskIndex = index
                                showEditTasksDetails = true
                            }
                            .foregroundColor(Color.black)
                            .listRowBackground(viewModel.getTaskBackgroundColor(index: index,status:tasks[index].status).swiftUIColor)
                        }
                    }
                    .onDelete(perform: viewModel.deleteTask)
                }
                .navigationDestination(isPresented: $showEditTasksDetails) {
                    TaskView(
                        viewModel:viewModel.taskViewModel,
                        tasksList: $tasks
                    )
                }
                .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
                .frame(maxWidth: .infinity)
                
            }
            else {
                Spacer()
                
                Text("Tasks Not Found")
                    .frame(maxWidth: .infinity)
                
                Spacer()
            }
        }
        .onAppear {
            navigationView = true
        }
        .toolbarBackground(tasks.count > 0 ? .visible : .hidden, for: .navigationBar)
        .toolbarBackground(.white, for: .navigationBar)
        .navigationBarLeadingViewModifier(withTitle: "Project Tasks", withColor: settingsViewModel.appAppearance)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
             HStack {
                Spacer()
            
                Button("Add"){
                    viewModel.taskViewModel.newTask = true
                    viewModel.taskViewModel.selectedTaskIndex = nil
                    showNewTasksDetails = true
                }
                .foregroundColor(.blue)
                .fontWeight(.bold)
                .navigationDestination(isPresented: $showNewTasksDetails) {
                   TaskView(viewModel:viewModel.taskViewModel,tasksList: $tasks)
                    
                }
            }
            .padding(.vertical, 10)
        )
        .background(settingsViewModel.appAppearance.themeBackgroundColor)
    }
}
