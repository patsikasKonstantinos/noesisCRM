//
//  GoalSettingsViewHeader.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 17/6/23.
//

import SwiftUI

extension GoalSettingsView{

    func GoalSettingsViewHeader()  -> some View {
        
        Text("Save")
            .foregroundColor(!viewModel.showingAlert ? .blue : .blue.opacity(0.3))
            .fontWeight(.bold)
            .onTapGesture {
                if !viewModel.showingAlert {
                    viewModel.saveGoalSettings()
                }
            }
            .onReceive(viewModel.dismissRequest) { _ in
                dismiss() //
            }
    }
}
 
