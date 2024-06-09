//
//  PaymentViewHeader.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 19/6/23.
//

import SwiftUI

extension PaymentView {
    
    func PaymentViewHeader()  -> some View {
        
        //Save or Add
        Text(viewModel.hiddenContacts ? "Submit" : "Save")
            .foregroundColor(!viewModel.showingAlert ? .blue : .blue.opacity(0.3))
            .fontWeight(.bold)
            .onTapGesture {
                  if !viewModel.showingAlert {
                    viewModel.inputTextStringsController = inputTextStringsController
                    viewModel.savePayment(
                        title:viewModel.inputTextStringsController[0],
                        comments:viewModel.inputTextStringsController[2],
                        paymentDate:viewModel.paymentDate,
                        paymentPrice: paymentPrice
                    )
                    if viewModel.hiddenContacts {
                        allPaymentsList = viewModel.allPaymentsList
                    }
                }
            }
            .onReceive(viewModel.dismissRequest) { _ in
                dismiss() //
            }
    }
}
 
