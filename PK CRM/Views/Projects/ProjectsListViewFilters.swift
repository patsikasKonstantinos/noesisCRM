//
//  ProjectsListViewFilters.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 22/6/23.
//

import SwiftUI
 
extension ProjectsListView {
    
    func ProjectsListViewFilters() -> some View {
        Picker("Status", selection: $viewModel.selectedStatus) {
           Text("All").tag(0)
           Text("Opened").tag(1)
        }
        .pickerStyle(.segmented)
        
    }
     
}

