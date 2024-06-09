//
//  SelectTasksViewDynamic
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 31/12/22.
//

import SwiftUI
 
struct SelectTasksViewDynamic: View {
    
    //MARK: Variables
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SelectTasksViewModelDynamic
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @Binding var selectedTasks:[Int:[Tasks]]
    @State var tasks:[Tasks] = []
    let index:Int

    //MARK: Initialization
    init(viewModel: SelectTasksViewModelDynamic,selectedTasks: Binding<[Int:[Tasks]]>,index:Int) {
        self.viewModel = viewModel
        _selectedTasks = selectedTasks
        self.index = index
    }

    //MARK: Body
    var body: some View {
        VStack {
            if viewModel.tasks.count > 0 {
                
                List {
                    ForEach(0..<viewModel.filteredTasks.count, id: \.self) { index in
                        Button {
                                viewModel.editExistedTaskSheet.toggle()
                                viewModel.selectedTaskIndex = index
                            } label: {
                                Text(!viewModel.tasks[index].code.isEmpty ? viewModel.tasks[index].code + ", " + viewModel.tasks[index].title : viewModel.tasks[index].title)
                                    .foregroundColor(Color.black)
                            }
                            .listRowBackground(viewModel.getTaskBackgroundColor(index: index).swiftUIColor)
                    }
                    .onDelete(perform: viewModel.deleteTask)
                }
                .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
                .frame(maxWidth: .infinity)
              
            } else {
                Spacer()
                
                Text("Tasks Not Found")
                    .frame(maxWidth: .infinity)
                
                Spacer()
            }
        }
        .onChange(of:tasks){ newValue in
            viewModel.tasks = newValue
        }
        .onAppear{
            if !viewModel.initialized {
                viewModel.setup(selectedTasks[index] ?? [])
                tasks = selectedTasks[index] ?? []
                viewModel.initialized = false
            }
        }
        .toolbarBackground(selectedTasks.count > 0 ? .visible : .hidden, for: .navigationBar)
        .toolbarBackground(.white, for: .navigationBar)
        .navigationBarLeadingViewModifier(
            withTitle: "Project Tasks", withColor: settingsViewModel.appAppearance
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
             HStack {
                Spacer()
                
                NavigationLink{
 
                    TaskView(viewModel:viewModel.taskListViewModel,
                            tasksList: $tasks)
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
