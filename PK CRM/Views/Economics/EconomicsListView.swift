//
//  EconomicsListView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 18/6/23.
//

import SwiftUI

struct EconomicsListView: View {
    
    //MARK: Variables
    @ObservedObject private var viewModel: EconomicsListViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    //MARK: Initialization
    init(viewModel: EconomicsListViewModel) {
        self.viewModel = viewModel
    }
    
    //MARK: Body
    var body: some View {
        VStack {
            if viewModel.payments.count > 0 {
                List {
                    ForEach(Array(viewModel.filteredPayments.enumerated()), id: \.1.id) { index, payment in

                        if !payment.isInvalidated {
                            ZStack{
                                NavigationLink{
                                    PaymentView(
                                        viewModel:PaymentViewModel(
                                            selectedPayment:payment,
                                            contactId: nil,
                                            newPayment: false,
                                            isIncome: viewModel.income,
                                            isExpenses:viewModel.expenses,
                                            hiddenContacts: false
                                        ),
                                        allPaymentsList:$viewModel.allPaymentsList
                                    )
                                } 
                                label: {
                                    Text(
                                       payment.title+" \(!payment.customers.isEmpty ? ", "+payment.customers[0].firstName : "") \(!payment.customers.isEmpty ? payment.customers[0].surnName : "" ), \(payment.price) \(Variables.currency)")
                                       .foregroundColor(Color.black)
                                }
                            }
                        }
                    }
                    .onDelete(perform: viewModel.deletePayment)
                }
                .frame(maxWidth: .infinity)
                .scrollContentBackground(.hidden)
            } 
            else {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Text(viewModel.income ? "Incomes Not found" : "Expenses Not found")
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
        .navigationBarLeadingViewModifier(withTitle: viewModel.income ? "Incomes" : "Expenses", withColor: settingsViewModel.appAppearance)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
            HStack {
                Spacer()
        
                NavigationLink{
                    PaymentView(
                        viewModel:PaymentViewModel(
                            selectedPayment:viewModel.selectedPayment,
                            contactId: nil,
                            newPayment: true,
                            isIncome: viewModel.income,
                            isExpenses:viewModel.expenses,
                            hiddenContacts: false
                        ),
                        allPaymentsList:$viewModel.allPaymentsList
                    )
                } label: {
                    Text("Add")
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                }
            }
            .padding(.vertical, 10)
        )
        .background(settingsViewModel.appAppearance.themeBackgroundColor)
    }

     
}
