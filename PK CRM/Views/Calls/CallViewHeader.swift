//
//  CallViewHeader.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 17/6/23.
//

import SwiftUI

extension CallView {
    
    func CallViewHeader() -> some View {
        
        Text("Save")
            .foregroundColor(!viewModel.showingAlert ? .blue : .blue.opacity(0.3))
            .fontWeight(.bold)
            .onTapGesture {
                if !viewModel.showingAlert {
                    viewModel.saveCall()
                }
            }
            .onReceive(viewModel.dismissRequest) { _ in
                dismiss() //
            }
    }
}
