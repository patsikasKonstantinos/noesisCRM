//
//  EvaluationViewHeader.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 18/6/23.
//

import SwiftUI

extension EvaluationView{
    
    func EvaluationViewHeader()  -> some View {
        
        Text("Save")
            .foregroundColor(!viewModel.showingAlert ? .blue : .blue.opacity(0.3))
            .fontWeight(.bold)
            .onTapGesture {
                if !viewModel.showingAlert {
                    viewModel.saveEvaluation()
                }
            }
            .onReceive(viewModel.dismissRequest) { _ in
                dismiss() //
            }
    }
}
