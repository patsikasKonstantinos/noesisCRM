//
//  MeetingView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 28/7/23.
//

import SwiftUI

struct MeetingView: View {
    
    //MARK: Variables
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @ObservedObject var viewModel: MeetingViewModel
    @State var showingAlertAnimation = false
    @State var fromNavigation:Bool = false

    //MARK: Initialization
    init(viewModel: MeetingViewModel) {
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
                            if index == 0 {
                                Text("\(viewModel.listViewItems[index]!.name):")
                                    .foregroundColor(viewModel.filledTitle ? Color.black.opacity(0.6) : Color.red)
                                    .font(.system(size: 16))
                                    .frame(width: 50, alignment: .leading)
                            } else {
                                Text("\(viewModel.listViewItems[index]!.name):")
                                    .foregroundColor(Color.black.opacity(0.6))
                                    .font(.system(size: 16))
                                    .frame(width: viewModel.listViewItems[index]!.type == 5 ? 50 : 100, alignment: .leading)
                            }

                            if viewModel.listViewItems[index]!.type == 1 {
                                TextField(
                                    "",
                                    text: $viewModel.inputTextStringsController[index],
                                    onEditingChanged: { isBegin in
                                        // Change Required Fields Colors
                                        if isBegin {
                                            viewModel.filledTitle = true
                                        }
                                    }
                                )
                            }
                            else if viewModel.listViewItems[index]!.type == 5 {
                                DatePicker("", selection: $viewModel.date, displayedComponents: [.date, .hourAndMinute])
                                    .padding(.top, 5)
                                    .padding(.bottom, 5)
                            }
                            else if viewModel.listViewItems[index]!.type == 6 {
                                NavigationLink{
                                    SelectContactsView(viewModel:viewModel.selectContactsViewModel,fromNavigation:$fromNavigation)
                                    .navigationBarLeadingViewModifier(
                                        withTitle: "Contacts", withColor: settingsViewModel.appAppearance
                                    )
                                    .navigationBarTitleDisplayMode(.inline)
                                } label: {
                                    VStack(alignment: .leading) {
                                        if (viewModel.selectContactsViewModel.selected.count > 0){
                                            ForEach(0..<viewModel.selectContactsViewModel.selected.count, id: \.self) { i in
                                                if(!viewModel.selectContactsViewModel.selected[i].isInvalidated) {
                                                    Text("\(viewModel.selectContactsViewModel.selected[i].firstName) \(viewModel.selectContactsViewModel.selected[i].surnName)")
                                                        .foregroundColor(.blue)
                                                        .font(.system(size: 15))
                                                        .padding(.leading, 5)

                                                    if(viewModel.selectContactsViewModel.selected[i] != viewModel.selectContactsViewModel.selected.last) {
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
                            else if viewModel.listViewItems[index]!.type == 2 {
                                Toggle("", isOn: $viewModel.completed)
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
        .navigationBarLeadingViewModifier(withTitle: "Meeting Details", withColor: settingsViewModel.appAppearance)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing: MeetingViewHeader().padding(.vertical, 10)
        )
        .onAppear{
            if !fromNavigation{
                viewModel.resetForm()
            }
        }
    }
}
