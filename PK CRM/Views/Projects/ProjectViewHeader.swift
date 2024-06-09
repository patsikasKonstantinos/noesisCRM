//
//  ProjectViewHeader.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 13/6/23.
//

import SwiftUI

extension ProjectView {
    
    func ProjectViewHeader() -> some View {
        HStack {
            Button(action: {dismiss()}) {
                Text("Back")
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            Text("Project Details")
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            Spacer()
            
            Button(action: {
                if !viewModel.showAlert {
                    viewModel.saveProject()
                }
            }){
                Text("Save")
                    .foregroundColor(!viewModel.showAlert ? .blue : .blue.opacity(0.3))
                    .fontWeight(.bold)
            }
        }
        .onReceive(viewModel.dismissRequest) { _ in
            dismiss() //
        }
        .padding(.horizontal, 15)
        .frame(height: 60)
     }
}
