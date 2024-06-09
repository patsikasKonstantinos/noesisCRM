//
//  ProjectsViewModel.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 11/6/23.
//

import Foundation
import RealmSwift

class ProjectsListViewModel: ObservableObject {
    @ObservedResults(Projects.self) var allProjects
    
    //MARK: Published Properties
    @Published var searchText = ""
    @Published var listCount:Int = 0
    @Published var shouldUpdateList:Bool = false
    @Published var showingAlert:Bool = false
    @Published var editExistedProjectSheet:Bool = false
    @Published var showingAddNewProjectSheet:Bool = false
    @Published var projectID:ObjectId?
    @Published var dataLoaded:Bool = false
    @Published var selectedStatus:Int = 0
    @Published var addNewEntry = false
    
    //MARK: let Properties
    private let projectsFunctionality: ProjectsFunctionality
    
    //MARK: var Properties
    private var notificationToken:NotificationToken?
    
    var projects: [Projects] {
        //All
        if selectedStatus == 0 {
            return Array(allProjects.sorted(byKeyPath: "finishDate", ascending: true))
        }
        else{
            //Opened
            return Array(allProjects.filter("status = %@", 0).sorted(byKeyPath: "finishDate", ascending: true) )
        }
    }

    var filteredProjects: [Projects] {
        if searchText.isEmpty {
            return projects
        }
        else {
            return projects.filter { project in
                projectsFunctionality.findProjects(searchText:searchText, project)
            }
        }
    }

    //MARK: Initialization
    init(projectsFunctionality: ProjectsFunctionality) {
        self.projectsFunctionality = projectsFunctionality
        notificationToken = RealmManager.shared.realm.observe { [weak self] (_ ,_)  in
            self?.objectWillChange.send()
        }
    }
    
    deinit {
        // Invalidate the token when the object is deallocated
        notificationToken?.invalidate()
    }

    //MARK: Functions
    func projectsListStatusFilter(_ status:Int){
        selectedStatus = status
    }
    
    func updateListId(){
        shouldUpdateList.toggle()
        listCount = allProjects.count
    }
    
    func findProjectStatusColor(_ status:Int) -> AppColors {
        var color:AppColors
        if status == 1 || status == 2 || status == 3 {
             color = Variables.projectStatusColorsV2[status]!
        }else{
             color = Variables.projectStatusColorsV2[0]!
        }
        return color
    }
    
    func deleteProjects(projectId:ObjectId) {
        projectsFunctionality.deleteProjects(projectId)
        updateListId()
    }
}
