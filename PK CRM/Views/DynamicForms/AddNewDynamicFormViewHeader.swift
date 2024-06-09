//
//  AddNewDynamicFormViewHeader.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 19/6/23.
//

import SwiftUI

extension AddNewDynamicFormView{

    func AddNewDynamicFormViewHeader()  -> some View {
                
        Text("Save")
            .foregroundColor(!viewModel.showingAlert ? .blue : .blue.opacity(0.3))
            .fontWeight(.bold)
            .onTapGesture {
                if !viewModel.showingAlert {
                    viewModel.saveNewDynamicForm()
                     
                }
            }
            .onReceive(viewModel.dismissRequest) { _ in
                dismiss() //
            }
    }
}
 
