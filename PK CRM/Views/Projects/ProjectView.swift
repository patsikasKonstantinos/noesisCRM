//
//  ProjectView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 13/6/23.
//

import SwiftUI

struct ProjectView: View {

    //MARK: Variables
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ProjectViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @State var showingAlertAnimation = false
    @State var selectedContacts:[Contacts] = []
    @State var fromNavigation:Bool = false

    //MARK: Initialization
    init(viewModel: ProjectViewModel) {
        self.viewModel = viewModel
        viewModel.setup()
    }
    
    //MARK: Body
    var body: some View {
        NavigationStack {
            VStack {
                ProjectViewHeader()
                
                if !showingAlertAnimation {
                    List {
                        ForEach(0..<viewModel.listViewItems.count, id: \.self) { index in
                            HStack {
                                // Name Another Colors
                                if index == 0 {
                                    Text("\(viewModel.listViewItems[index]!.name):")
                                        .foregroundColor(viewModel.filledCode ? Color.black.opacity(0.6) : Color.red)
                                        .font(.system(size: 16))
                                        .frame(width: 50, alignment: .leading)
                                } else if index == 1 {
                                    Text("\(viewModel.listViewItems[index]!.name):")
                                        .foregroundColor(viewModel.filledTitle ? Color.black.opacity(0.6) : Color.red)
                                        .font(.system(size: 16))
                                        .frame(width: 50, alignment: .leading)
                                } else if index == 6 {
                                    Text("\(viewModel.listViewItems[index]!.name)")
                                        .foregroundColor(Color.black.opacity(0.6))
                                        .font(.system(size: 16))
                                        .frame(width: 50, alignment: .leading)
                                } else {
                                    Text("\(viewModel.listViewItems[index]!.name):")
                                        .foregroundColor(Color.black.opacity(0.6))
                                        .font(.system(size: 16))
                                        .frame(width: 100, alignment: .leading)
                                }
                                
                                if viewModel.listViewItems[index]!.type == 1 {
                                    TextField(
                                        "",
                                        text: $viewModel.inputTextStringsController[index],
                                        onEditingChanged: { isBegin in
                                            // Change Required Fields Colors
                                            if isBegin {
                                                if index == 0 {
                                                    viewModel.filledCode = true
                                                }
                                                if index == 1 {
                                                    viewModel.filledTitle = true
                                                }
                                            }
                                        }
                                    )
                                }
                                else if viewModel.listViewItems[index]!.type == 3 {
                                    Picker(
                                        selection: $viewModel.statusSelection,
                                        label: Text("")) {
                                        ForEach(0..<viewModel.projectStatus.count, id: \.self) { statusCount in
                                            Text("\(viewModel.projectStatus[statusCount]!)")
                                                .tag(statusCount)
                                        }
                                    }
                                }
                                else if viewModel.listViewItems[index]!.type == 5 {
                                    // Start Date
                                    if index == 3 {
                                        DatePicker("", selection: $viewModel.startDate, displayedComponents: [.date])
                                            .padding(.top, 5)
                                            .padding(.bottom, 5)
                                    }
                                    // Finish Date
                                    if index == 4 {
                                        DatePicker("", selection: $viewModel.finishDate, displayedComponents: [.date])
                                            .padding(.top, 5)
                                            .padding(.bottom, 5)
                                    }
                                }
                                else if viewModel.listViewItems[index]!.type == 6 {
                                    
                                    NavigationLink {
                                        SelectContactsView(viewModel:viewModel.selectContactsViewModel,fromNavigation:$fromNavigation)
//                                        .navigationTitle("Contacts")
                                        .navigationBarLeadingViewModifier(withTitle: "Contacts", withColor: settingsViewModel.appAppearance)
                                        .navigationBarTitleDisplayMode(.inline)
                                     } label :{
                                         
                                         //HACK IF IS INIT SETUP OR NOT
                                         if !fromNavigation{
                                             VStack(alignment: .leading) {
                                                
                                                 if viewModel.selectContactsViewModel.selected.count > 0 {
                                                    ForEach(0..<viewModel.selectContactsViewModel.selected.count,id:\.self) { i in
                                                        if !viewModel.selectContactsViewModel.selected[i].isInvalidated {
                                                            Text("\(viewModel.selectContactsViewModel.selected[i].firstName) \(viewModel.selectContactsViewModel.selected[i].surnName)")
                                                                .foregroundColor(.blue)
                                                                .font(.system(size: 15))
                                                                .padding(.leading, 5)
                                                            
                                                            if viewModel.selectContactsViewModel.selected[i] != viewModel.selectContactsViewModel.selected.last {
                                                                Divider()
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                             
                                         }
                                         else{
                                             VStack(alignment: .leading) {
                                                
                                                if selectedContacts.count > 0 {
                                                    ForEach(0..<selectedContacts.count,id:\.self) { i in
                                                        if !selectedContacts[i].isInvalidated {
                                                            Text("\(selectedContacts[i].firstName) \(selectedContacts[i].surnName)")
                                                                .foregroundColor(.blue)
                                                                .font(.system(size: 15))
                                                                .padding(.leading, 5)
                                                            
                                                            if selectedContacts[i] != selectedContacts.last {
                                                                Divider()
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                             
                                         }
                                    }
                                    
                                } else if viewModel.listViewItems[index]!.type == 7 {
                                    NavigationLink{
                                        TasksListView(
                                            viewModel: TasksListViewModel(),
                                            tasks: $viewModel.projectTasks,
                                            navigationView: $viewModel.fromNavigation 
                                        )
                                    } label:{}
                                }
                            }
                        }
                        if !viewModel.newProject {
                            Section{
                                HStack {
                                    Text("Delete")
                                        .foregroundColor(Color.red)
                                 }
                                .frame(maxWidth: .infinity, alignment: .center)
                                .background(.white)
                                .onTapGesture {
                                    viewModel.showDeleteAlert = true
                                }
                            }
                            .alert(isPresented: $viewModel.showDeleteAlert) {
                                Alert(
                                    title: Text("Are you sure you want to delete this Project?")
                                        .foregroundColor(Color.black)
                                        .font(.system(size: 16))
                                        .fontWeight(.bold),
                                    message: Text(""),
                                    primaryButton: .default(Text("Cancel"), action: {}),
                                    secondaryButton: .destructive(Text("Delete"), action: {
                                        viewModel.deleteProject()
                                    }))
                            }
                        }
                    }
                }
                else {
                    Spacer()
                    
                    WarningAlertView(
                        showingAlert: $viewModel.showAlert,
                        text: $viewModel.alertMessage,
                        title: "Oops,",
                        width: 300,
                        height: 300,
                        scrollable: false
                    )
                    .interactiveDismissDisabled()
                    
                    Spacer()
                }
            }
            .onAppear{
                if !fromNavigation{
                    viewModel.resetForm()
                }
                else{
                    selectedContacts = viewModel.selectContactsViewModel.selected
                }
            }

            .onChange(of: viewModel.showAlert) { newValue in
                withAnimation {
                    showingAlertAnimation = newValue
                }
            }
            .frame(maxWidth: .infinity)
            .background(settingsViewModel.appAppearance.themeBackgroundColor)
        }
    }
}
