import SwiftUI

extension ContactView {
    
    func contactsFinancialDetailsView() -> some View {
        
        return  VStack {
            if (viewModel.paymentsCount(allPaymentsList.filter { !$0.isInvalidated }, openedTab) > 0) {
                List {
                    ForEach(allPaymentsList.filter { !$0.isInvalidated }) { payment in
                        
                        if viewModel.filteredPayments(payment,openedTab) {
                            Button(payment.title + ", " + "\(payment.price) \(Variables.currency)"){
                                showPaymentsDetails = true
                                viewModel.paymentViewModelEdit.selectedPayment = payment
                                viewModel.paymentViewModelEdit.isIncome = payment.isIncome
                                viewModel.paymentViewModelEdit.isExpenses = payment.isExpenses
                                viewModel.paymentViewModelEdit.contactId = viewModel.contactId
                            }
                            .foregroundColor(Color.black)
                            .listRowBackground(payment.isIncome ? Color.green.opacity(0.5) : Color.red.opacity(0.5))
                        }else{
                            EmptyView()
                        }
                    }
                    .onDelete(perform:deletePayment)
                }
                .navigationDestination(isPresented: $showPaymentsDetails) {
                    PaymentView(
                        viewModel: viewModel.paymentViewModelEdit,
                        allPaymentsList: $allPaymentsList
                    )
                }
                .frame(maxWidth: .infinity)
                .scrollContentBackground(.hidden)
            } else {
                Spacer()
                
                Text(openedTab == 2 ? "Income Not Found" : "Expenses Not Found")
                
                Spacer()
            }
            
            HStack {
                Spacer()
                
                NavigationLink{
                    PaymentView(
                        viewModel:viewModel.paymentViewModelNew,
                        allPaymentsList: $allPaymentsList
                    )
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(Color.black)
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
        }
    }
    
    func deletePayment(at offsets: IndexSet) {
        let index = offsets[offsets.startIndex]
        allPaymentsList.remove(at: index)
        viewModel.allPaymentsList = allPaymentsList
    }
}
