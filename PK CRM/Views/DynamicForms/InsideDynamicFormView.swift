//
//  InsideDynamicFormView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 25/4/23.
//

import SwiftUI
 
struct InsideDynamicFormView: View {
    
    //MARK: Variables
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: InsideDynamicFormViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @State var showingAlertAnimation:Bool = false
    @State var fromNavigation:Bool = false
    @State var selectedContacts:[Int:[Contacts]]
    @State var selectedProjects:[Int:[Projects]]
    @State var selectedTasks:[Int:[Tasks]]
 
    //MARK: Initialization
    init(viewModel: InsideDynamicFormViewModel) {
        self.viewModel = viewModel
        viewModel.setup()
        _selectedContacts =  State(initialValue: viewModel.selectedContacts)
        _selectedProjects =  State(initialValue: viewModel.selectedProjects)
        _selectedTasks =  State(initialValue: viewModel.selectedTasks)
    }
     
    //MARK: Body
    var body: some View {
        VStack{
            
            if(showingAlertAnimation){
                //ALERT VIEW
                WarningAlertView(
                    showingAlert:$viewModel.alertView,
                    text: $viewModel.requiredFieldsText,
                    title: "Oops",
                    width: 0,
                    height: 0,
                    scrollable:true)
                .interactiveDismissDisabled()
            }else{
                List{
                    InsideDynamicFormViewItems()
                }
                .scrollContentBackground(.hidden)
            }
        }
        .onAppear{
            if !fromNavigation {
                viewModel.resetForm()
            }
        }
        .onChange(of: viewModel.alertView) { newValue in
            withAnimation {
                showingAlertAnimation = newValue
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("")
        .navigationBarItems(trailing:
            HStack{
                Spacer()
                
                Text("Save")
                    .onTapGesture{
                        if !viewModel.alertView{
                            viewModel.checkRequiredFields()
                        }
                    }
                    .onReceive(viewModel.dismissRequest) { _ in
                        dismiss() //
                    }
                    .foregroundColor(!viewModel.alertView ? .blue : .blue.opacity(0.3))
                    .fontWeight(.bold)
            }
            .padding(.vertical,10)
        )
        .frame(maxWidth:.infinity,maxHeight:.infinity,alignment: .center)
        .background(settingsViewModel.appAppearance.themeBackgroundColor)
    }
}
