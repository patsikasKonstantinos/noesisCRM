//
//  MeetingViewHeader.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 16/6/23.
//

import SwiftUI

extension MeetingView {
    
    func MeetingViewHeader() -> some View {
        
        Text("Save")
            .foregroundColor(!viewModel.showingAlert ? .blue : .blue.opacity(0.3))
            .fontWeight(.bold)
            .onTapGesture {
                if !viewModel.showingAlert {
                    viewModel.saveMeeting()
                }
            }
            .onReceive(viewModel.dismissRequest) { _ in
                dismiss() //
            }
    }
}

