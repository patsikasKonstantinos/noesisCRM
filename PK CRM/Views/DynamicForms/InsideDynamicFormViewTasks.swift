//
//  InsideDynamicFormViewTasks.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 20/6/23.
//

import SwiftUI

extension InsideDynamicFormView{
    
    func insideDynamicFormViewTasks(_ tasksController:[Tasks],_ index:Int) -> some View{
        
        NavigationLink{
            TasksListView(
                viewModel:viewModel.tasksListViewModel,
                tasks: Binding(
                    get: {tasksController},
                    set: {viewModel.inputController[index] = $0 }),
                navigationView:$fromNavigation
            )
        } label: {}
    }
}

 
