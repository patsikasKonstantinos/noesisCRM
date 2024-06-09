//
//  SelectTasksViewModelDynamic.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 17/6/23.
//

import Foundation
import RealmSwift
import Combine

class SelectTasksViewModelDynamic: ObservableObject {
 
    //MARK: Published Properties
    @Published var tasks: [Tasks] = []
    @Published var searchText = ""
    @Published var displaySearch = false
    @Published var listRowBackgroundColor: [Int: AppColors] = [:]
    @Published var showingAddNewTaskSheet = false
    @Published var editExistedTaskSheet = false
    @Published var selectedTaskIndex: Int?
    @Published var addNewEntry = false
    @Published var initialized = false
    
    //MARK: let Properties
    private let taskFunctionality = TasksFunctionality()
    let taskListViewModel = TaskViewModel(newTask: true, selectedTaskIndex:nil)
    
    //MARK: var Properties
    var filteredTasks: [Tasks] {
        if searchText.isEmpty {
            return tasks
        }
        else {
            return tasks.filter { task in
                taskFunctionality.findTasks(searchText: searchText, task)
            }
        }
    }
    
    //MARK: Functions
    func setup(_ initTasks:[Tasks]){
        tasks = initTasks
    }

    func deleteTask(offsets: IndexSet) {
        let index = offsets[offsets.startIndex]
        tasks.remove(at: index)
    }
    
    func getTaskBackgroundColor(index: Int) -> AppColors {
        let status = tasks[index].status
        var color:AppColors
        if status == 1 || status == 2 || status == 3 {
             color = Variables.projectStatusColorsV2[status]!
        }
        else{
             color = Variables.projectStatusColorsV2[0]!
        }
        return color
    }
}
