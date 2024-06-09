//
//  CallView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 17/6/23.
//

import SwiftUI

struct CallView: View {

    //MARK: Variables
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: CallViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @State var showingAlertAnimation = false
    @State var fromNavigation:Bool = false

    //MARK: Initialization
    init(viewModel: CallViewModel) {
        self.viewModel = viewModel
        viewModel.setup() // Call the setup function here
    }

    //MARK: Body
    var body: some View {
        VStack {
            
            if !showingAlertAnimation {
                List {
                    ForEach(0..<viewModel.listViewItems.count, id: \.self) { index in
                        HStack {
                            // Users
                            if index == 0 {
                                Text("\(viewModel.listViewItems[index]!.name):")
                                    .foregroundColor(viewModel.filledUser ? Color.black.opacity(0.6) : Color.red)
                                    .font(.system(size: 16))
                                    .frame(width: 120, alignment: .leading)
                                    .onAppear {
                                        viewModel.checkIfUserFieldIsFilled()
                                    }
                            }
                            else {
                                Text("\(viewModel.listViewItems[index]!.name):")
                                    .foregroundColor(Color.black.opacity(0.6))
                                    .font(.system(size: 16))
                                    .frame(width: index == 1 ? 120 : viewModel.listViewItems[index]!.type == 5 ? 50 : 100,
                                           alignment: .leading)
                            }

                            if viewModel.listViewItems[index]!.type == 1 {
                                TextField(
                                    "",
                                    text: $viewModel.inputTextStringsController[index],
                                    onEditingChanged: { isBegin in
                                        // Change Required Fields Colors
                                        if isBegin {
                                        }
                                    }
                                )
                            } else if viewModel.listViewItems[index]!.type == 5 {
                                // Date Picker
                                DatePicker(
                                    "",
                                    selection: $viewModel.date,
                                    displayedComponents: [.date, .hourAndMinute]
                                )
                                .padding(.top, 5)
                                .padding(.bottom, 5)
                            } else if viewModel.listViewItems[index]!.type == 6 {
                                // Select Another Table Customers
                                     NavigationLink{
                                        
                                         SelectContactsView(
                                            viewModel:index == 0 ? viewModel.selectUsersViewModel : viewModel.selectContactsViewModel,fromNavigation:$fromNavigation
                                         )
 
//                                      .navigationTitle("\(viewModel.listViewItems[counter]!.name)")
                                        .navigationBarLeadingViewModifier(withTitle: "\(viewModel.listViewItems[index]!.name)", withColor: settingsViewModel.appAppearance)

                                        .navigationBarTitleDisplayMode(.inline)
                                    } label: {
                                        VStack(alignment: .leading) {
                                            // Users
                                            if index == 0 {
                                                if viewModel.selectUsersViewModel.selected.count > 0 {
                                                    ForEach(0..<viewModel.selectUsersViewModel.selected.count, id: \.self) { i in
                                                        if !viewModel.selectUsersViewModel.selected[i].isInvalidated {
                                                            Text("\(viewModel.selectUsersViewModel.selected[i].firstName) \(viewModel.selectUsersViewModel.selected[i].surnName)")
                                                                .foregroundColor(.blue)
                                                                .font(.system(size: 15))
                                                                .padding(.leading, 5)
                                                        }
                                                    }
                                                }
                                            }
                                            // Contacts
                                            else {
                                                if viewModel.selectContactsViewModel.selected.count > 0 {
                                                    ForEach(0..<viewModel.selectContactsViewModel.selected.count, id: \.self) { i in
                                                        if !viewModel.selectContactsViewModel.selected[i].isInvalidated {
                                                            Text("\(viewModel.selectContactsViewModel.selected[i].firstName) \(viewModel.selectContactsViewModel.selected[i].surnName)")
                                                                .foregroundColor(.blue)
                                                                .font(.system(size: 15))
                                                                .padding(.leading, 5)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                
                            } else if viewModel.listViewItems[index]!.type == 8 {
                                // Textarea
                                TextField(
                                    "",
                                    text: $viewModel.inputTextStringsController[index],
                                    axis: .vertical
                                )
                                .fixedSize(horizontal: false, vertical: true)
                                .multilineTextAlignment(.leading)
                                .padding(10)
                                .background(Color.black.opacity(0.02))
                                .cornerRadius(15)
                            } else if viewModel.listViewItems[index]!.type == 9 {
                                // Double
                                NumberTextField(text: $viewModel.inputTextStringsController[index])
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }

            else {
                // ALERT VIEW
                Spacer()
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
            }
        }
        .frame(maxWidth: .infinity)
        .background(settingsViewModel.appAppearance.themeBackgroundColor)
        .onChange(of: viewModel.showingAlert) { newValue in
               
            withAnimation {
                showingAlertAnimation = newValue
            }
        }
//        .navigationTitle("Call Details")
        .navigationBarLeadingViewModifier(withTitle: "Call Details", withColor: settingsViewModel.appAppearance)

        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: CallViewHeader().padding(.vertical, 10))
        .onAppear{
            if !fromNavigation{
                viewModel.resetForm()
            }
        }
    }
}
