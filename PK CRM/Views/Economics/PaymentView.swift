//
//  PaymentView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 28/2/23.
//

import SwiftUI

struct PaymentView: View {
    
    //MARK: Variables
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: PaymentViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @Binding var allPaymentsList: [Payments]
    @State var showingAlertAnimation = false
    @State var paymentPrice:String = ""
    @State var inputTextStringsController: [String] = ["", "", "", "", ""]
    @State var fromNavigation:Bool = false

    //MARK: Body
    var body: some View {
        VStack {
            
            if !showingAlertAnimation {
                List {
                    ForEach(0..<viewModel.paymentsViewItems.count, id: \.self) { index in
                        if index != 1 || (index == 1 && !viewModel.hiddenContacts) {
                            HStack{
                                if( index == 0 ) {
                                    Text("\(viewModel.paymentsViewItems[index]!.name):")
                                        .foregroundColor(viewModel.filledTitle ? Color.black.opacity(0.6) : Color.red)
                                        .font(.system(size: 16))
                                        .frame(width:50,alignment:.leading)
                                }
                                //Price
                                else if( index == 4 ) {
                                    Text("\(viewModel.paymentsViewItems[index]!.name):")
                                        .foregroundColor(Color.black.opacity(0.6))
                                        .font(.system(size: 16))
                                        .frame(width:100,alignment:.leading)
                                }
                                else{
                                    Text("\(viewModel.paymentsViewItems[index]!.name):")
                                        .foregroundColor(Color.black.opacity(0.6))
                                        .font(.system(size: 16))
                                        .frame(width:100,alignment:.leading)
                                    
                                }
                                
                                if viewModel.paymentsViewItems[index]!.type == 1 {
                                    TextField(
                                        "",
                                        text: $inputTextStringsController[index],
                                        onEditingChanged: { (isBegin) in
                                            //Change Required Fields Colors
                                            if isBegin {
                                                if(index == 0) {
                                                    viewModel.filledTitle = true
                                                }
                                            }
                                        }
                                    )
                                }
                                //Date Picker
                                else if viewModel.paymentsViewItems[index]!.type == 5 {
                                    // Date
                                    DatePicker("", selection: $viewModel.paymentDate,displayedComponents: [.date])
                                        .padding(.top,5)
                                        .padding(.bottom,5)
                                }
                                //Select Another Table Customers
                                else if viewModel.paymentsViewItems[index]!.type == 6 {
                                    //From economics List
                                    if viewModel.contactId == nil {
                                        NavigationLink{
                                            SelectContactsView(
                                                viewModel:viewModel.selectContactsViewModel,
                                                fromNavigation:$fromNavigation
                                            )
                                        } label: {
                                            VStack(alignment: .leading){
                                                
                                                if(viewModel.selectContactsViewModel.selected.count > 0) {
                                                    ForEach(0..<viewModel.selectContactsViewModel.selected.count, id: \.self){ i in
                                                        if(!viewModel.selectContactsViewModel.selected[i].isInvalidated) {
                                                            Text("\(viewModel.selectContactsViewModel.selected[i].firstName) \(viewModel.selectContactsViewModel.selected[i].surnName)")
                                                                .foregroundColor(.blue)
                                                                .font(.system(size: 15))
                                                                .padding(.leading,5)
                                                            
                                                            if(viewModel.selectContactsViewModel.selected[i] != viewModel.selectContactsViewModel.selected.last) {
                                                                Divider()
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            .frame(maxWidth:.infinity,alignment:.leading)
                                        }
                                    //From contact economics list
                                    }else{
                                        
                                        VStack(alignment: .leading){
                                            ForEach(viewModel.selectedContacts){ contact in
                                                Text("\(contact.firstName) \(contact.surnName)")
                                                    .foregroundColor(.blue)
                                                    .font(.system(size: 15))
                                                    .padding(.leading,5)
                                                
                                                if (contact != viewModel.selectedContacts.last) {
                                                    Divider()
                                                }
                                            }
                                        }
                                        .frame(maxWidth:.infinity,alignment:.leading)
                                    }
                                }
                                else if viewModel.paymentsViewItems[index]!.type == 8 {
                                    TextField(
                                        "",
                                        text: $inputTextStringsController[index],
                                        axis: .vertical
                                        
                                    )
                                    .fixedSize(horizontal: false, vertical: true)
                                    .multilineTextAlignment(.leading)
                                    .padding(10)
                                    .background(Color.black.opacity(0.02))
                                    .cornerRadius(15)
                                }
                                //PRICE
                                else if viewModel.paymentsViewItems[index]!.type == 9 {
                                    NumberTextField(text: $paymentPrice)
                                }
                            }
                            
                        }else{
                            EmptyView()
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            else{
                //ALERT VIEW
               Spacer()
                
               WarningAlertView(
                   showingAlert:$viewModel.showingAlert,
                   text: $viewModel.alertMessage,
                   title: "Oops,",
                   width: 300,
                   height: 300,
                   scrollable: false)
               .interactiveDismissDisabled()
                
               Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .background(settingsViewModel.appAppearance.themeBackgroundColor)
        .onChange(of: viewModel.showingAlert) { newValue in
            withAnimation {
                showingAlertAnimation = newValue
            }
        }
        .onAppear{
            //FROM CONTACT VIEW
            if viewModel.hiddenContacts {
                viewModel.allPaymentsList = allPaymentsList // Access the wrapped value
            }
        
            if !fromNavigation{
                viewModel.setup()
                if !viewModel.newPayment {
                    paymentPrice = "\(viewModel.selectedPayment!.price)"
                }
                viewModel.resetForm()
                inputTextStringsController = viewModel.inputTextStringsController
            }
        }
        .navigationBarLeadingViewModifier(
            withTitle: "Payment Details", withColor: settingsViewModel.appAppearance
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
            PaymentViewHeader()
                .padding(.vertical,10)
        )
    }
}
