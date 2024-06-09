//
//  ContactViewHeader.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 12/6/23.
//

import SwiftUI

// MARK: - ContactViewHeader
extension ContactView {
 
    func contactViewHeader()-> some View {
        Text("Save")
            .foregroundColor(!viewModel.showingAlert ? .blue : .blue.opacity(0.3))
            .fontWeight(.bold)
            .onTapGesture {
                viewModel.inputTextStringsController = inputTextStringsController
                // Save contact
                if !viewModel.showingAlert {
                    viewModel.allPaymentsList = allPaymentsList
                    viewModel.saveContact()
                }
            }
    }
}
