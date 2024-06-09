//
//  SelectProjectsViewModel.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 18/6/23.
//


import Foundation
import RealmSwift

class SelectProjectsViewModel: ObservableObject {
    @ObservedResults(Projects.self) var allProjects
    
    //MARK: Published Properties
    @Published var selectedProject = 0
    @Published var showingAddNewProjectSheet = false
    @Published var editExistedProjectSheet = false
    @Published var selected:[Projects] = []
    @Published var searchText = ""
    @Published var displaySearch = false
    
    //MARK: let Properties
    private let projectsFunctionality = ProjectsFunctionality()
    
    //MARK: var Properties
    var multiple:Bool
    
    var projects: [Projects] {
        return Array(allProjects.sorted(byKeyPath: "finishDate", ascending: true))
    }
    
    //MARK: Initialization
    init(multiple: Bool) {
        self.multiple = multiple
    }
    
    //MARK: Functions
    func isSelected(_ project:Projects) -> Bool {
        if selected.contains(where: { $0.id == project.id }){
            return true
        }
        else{
            return false
        }
    }
    
    func selectProjectsAction(_ project:Projects) -> [Projects] {
        if multiple {
            if selected.contains(where: { $0.id == project.id }) {
                selected.removeAll(where: { $0.id == project.id })
            }
            else{
                selected.append(project)
            }
        }
        else {
            if selected.count == 1 {
                if project.id == selected[0].id {
                    selected.removeAll()
                }
                else{
                    selected.removeAll()
                    selected.append(project)
                }
            }
            else{
                selected.removeAll()
                selected.append(project)
            }
        }
        return selected
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
}
