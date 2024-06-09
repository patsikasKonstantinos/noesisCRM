//
//  ContactView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 1/1/23.
//

import SwiftUI
 
 
struct ContactView: View {
    
    //MARK: Variables
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ContactViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @State var showingAlertAnimation = false
    @State var allPaymentsList: [Payments]
    @State var openedTab = 1
    @State var initialized:Bool
    @State var showPaymentsDetails:Bool = false
    @State var selectedPayment:Payments?
    @State var inputTextStringsController: [String] = Array(repeating: "", count: 12)

    //MARK: Body
    var body: some View {
        VStack {
            Spacer()
            
            if showingAlertAnimation {
                // Alert view
                WarningAlertView(
                    showingAlert: $viewModel.showingAlert,
                    text: $viewModel.alertText,
                    title: viewModel.alertTitle,
                    width: 300,
                    height: 300,
                    scrollable: false
                )
                .interactiveDismissDisabled()
                
                Spacer()
            }else{
                ContactViewTabs(openedTab: $openedTab)
                
                if openedTab == 1 {
                    contactDetailsView()
                } else if openedTab == 2 || openedTab == 3 {
                    // Incomes or expenses view
                    contactsFinancialDetailsView()
                } else if openedTab == 4 {
                    // Sum view
                    EconomicsContactSummation(
                        viewModel: EconomicsContactSummationViewModel(allPaymentsList: allPaymentsList)
                    )
                }
            }
        }
        .onAppear{
            if !initialized {
                viewModel.setup()
                allPaymentsList = viewModel.allPaymentsList
                viewModel.paymentViewModelNew.contactId = viewModel.contactId
                inputTextStringsController = viewModel.inputTextStringsController
                initialized = true
            }
            else {
                viewModel.checkTab(openedTab)
                viewModel.openedTab = openedTab
            }
            
        }
        .onChange(of: viewModel.showingAlert) { newValue in
            withAnimation {
                showingAlertAnimation = newValue
            }
        }
        .onChange(of: openedTab) { _ in
            viewModel.checkTab(openedTab)
        }
        .onReceive(viewModel.dismissRequest) { _ in
            dismiss() //
        }
        .navigationBarLeadingViewModifier(
            withTitle: "Contact Details", withColor: settingsViewModel.appAppearance
        )
        .navigationBarHidden(false)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: contactViewHeader())
        .frame(maxWidth: .infinity)
        .background(settingsViewModel.appAppearance.themeBackgroundColor)
    }
}
