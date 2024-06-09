//
//  ContactsListViewFilters.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 22/6/23.
//

import SwiftUI
 
extension ContactsListView {
    
    func ContactsListViewFilters() -> some View {
        Picker("Type", selection: $viewModel.selectedContactType) {
            Text("All").tag(0)
            Text("Customers").tag(1)
            Text("Suppliers").tag(2)
            Text("Employees").tag(3)

        }
        .pickerStyle(.segmented)
        
    }
}


