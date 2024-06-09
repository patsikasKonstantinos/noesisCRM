//
//  TasksListViewModel.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 17/6/23.
//

import Foundation
import RealmSwift
import Combine

class TasksListViewModel: ObservableObject {
    
    //MARK: Published Properties
    @Published var tasks: [Tasks] = []
    @Published var searchText = ""
    @Published var displaySearch = false
    @Published var listRowBackgroundColor: [Int: AppColors] = [:]
    @Published var showingAddNewTaskSheet = false
    @Published var editExistedTaskSheet = false
    @Published var selectedTaskIndex: Int?
    @Published var addNewEntry = false
    
    //MARK: let Properties
    private let taskFunctionality = TasksFunctionality()
    
    //MARK: var Properties
    lazy var taskViewModel: TaskViewModel = {
           return TaskViewModel(newTask: true, selectedTaskIndex:nil)
    }()
    
    //MARK: Functions
    func filteredTasks(_ task:Tasks) -> Bool {
        if searchText.isEmpty {
            return true
        } else {
           return taskFunctionality.findTasks(searchText: searchText, task)
        }
        
    }
 
    func deleteTask(offsets: IndexSet) {
        let index = offsets[offsets.startIndex]
        tasks.remove(at: index)
    }
    
    func getTaskBackgroundColor(index: Int,status:Int) -> AppColors {
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
