//
//  DaysOffView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 17/6/23.
//

import SwiftUI

struct DaysOffView: View {
    
    //MARK: Variables
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: DaysOffViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @State var showingAlertAnimation = false
    @State var selectedUsers:[Contacts] = []
    @State var fromNavigation:Bool = false
    
    //MARK: Initialization
    init(viewModel: DaysOffViewModel) {
        self.viewModel = viewModel
        viewModel.setup() // Call the setup function here
    }
    
    //MARK: Body
    var body: some View {
        NavigationView {
            VStack {
                DaysOffViewHeader()
                
                if(!showingAlertAnimation){
                    List {
                        ForEach(0..<viewModel.listViewItems.count, id: \.self) { index in
                            HStack {
                                Text("\(viewModel.listViewItems[index]!.name):")
                                    .foregroundColor(index == 1 ? (viewModel.filledUser ? .black.opacity(0.6) : .red) : .black.opacity(0.6))
                                    .font(.system(size: 16))
                                    .frame(width: 120, alignment: .leading)
                                
                                if viewModel.listViewItems[index]!.type == 5 {
                                    DatePicker("", selection: $viewModel.date, displayedComponents: [.date])
                                        .padding(.top, 5)
                                        .padding(.bottom, 5)
                                        .disabled(true)
                                }
                                else if viewModel.listViewItems[index]!.type == 6 {
                                        NavigationLink{
                                            SelectContactsView(
                                                viewModel:viewModel.selectUsersViewModel,
                                                fromNavigation:$fromNavigation
                                            )
                                            .navigationBarLeadingViewModifier(withTitle: "\(viewModel.listViewItems[index]!.name)", withColor: settingsViewModel.appAppearance)
                                            .navigationBarTitleDisplayMode(.inline)
                                        } label: {
                                            VStack(alignment: .leading) {
                                                if selectedUsers.count > 0 {
                                                    ForEach(0..<selectedUsers.count, id: \.self) { i in
                                                        if(!selectedUsers[i].isInvalidated) {
                                                            Text("\(selectedUsers[i].firstName) \(selectedUsers[i].surnName)")
                                                                .foregroundColor(.blue)
                                                                .font(.system(size: 15))
                                                                .padding(.leading, 5)
                                                            
                                                            if (selectedUsers[i] != selectedUsers.last) {
                                                                Divider()
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                }
                                else if viewModel.listViewItems[index]!.type == 8 {
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
                                }
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
                else {
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
            .onAppear{
                selectedUsers = viewModel.selectUsersViewModel.selected
            }
            .onChange(of: viewModel.showingAlert) { newValue in
                withAnimation {
                    showingAlertAnimation = newValue
                }
            }
        }
    }
}
