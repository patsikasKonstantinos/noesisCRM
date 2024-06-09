//
//  TaskView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 26/2/23.
//

import SwiftUI
 
struct TaskView: View {
    
    //MARK: Variables
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: TaskViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @Binding var tasksList:[Tasks]
    @State var initialized = false
    @State var fromNaviagation:Bool = false
    @State var showingAlertAnimation = false
     
    //MARK: Initialization
    init(viewModel: TaskViewModel, tasksList: Binding<[Tasks]>) {
        self.viewModel = viewModel
        _tasksList = tasksList
    }
    
    //MARK: Body
    var body: some View {
        
        VStack{
            TaskViewHeader()
            
            if(!showingAlertAnimation){
                List{
                    ForEach(0..<viewModel.listViewItems.count, id: \.self) { index in
                        HStack{
                            //Name Another Colors
                            if( index == 0 ) {
                                Text("\(viewModel.listViewItems[index]!.name):")
                                    .foregroundColor(viewModel.filledCode ? Color.black.opacity(0.6) : Color.red)
                                    .font(.system(size: 16))
                                    .frame(width:50,alignment:.leading)
                                
                            }
                            else if( index == 1){
                                Text("\(viewModel.listViewItems[index]!.name):")
                                    .foregroundColor(viewModel.filledTitle ? Color.black.opacity(0.6) : Color.red)
                                    .font(.system(size: 16))
                                    .frame(width:50,alignment:.leading)
                            }
                            else{
                                Text("\(viewModel.listViewItems[index]!.name):")
                                    .foregroundColor(Color.black.opacity(0.6))
                                    .font(.system(size: 16))
                                    .frame(width:100,alignment:.leading)
                            }
                                                         
                            if(viewModel.listViewItems[index]!.type == 1){
                                TextField(
                                    "",
                                    text: $viewModel.inputTextStringsController[index],
                                    onEditingChanged: { (isBegin) in
                                        //Change Required Fields Colors
                                        if isBegin {
                                            if(index == 0) {
                                                viewModel.filledCode = true
                                            }
                                            if(index == 1){
                                                viewModel.filledTitle = true
                                            }
                                        }
                                    }
                                )

                            }
                            else if(viewModel.listViewItems[index]!.type == 3){
                                Picker(selection: $viewModel.statusSelection,
                                   label: Text("")) {
                                        ForEach(0..<viewModel.projectStatus.count, id: \.self) { statusCount in
                                            Text("\(viewModel.projectStatus[statusCount]!)").tag(statusCount)
                                        }
                                }
                            }
                            //Date Picket
                            else if(viewModel.listViewItems[index]!.type == 5){
                                //Start Date
                                if index == 3 {
                                    DatePicker("", selection: $viewModel.startDate,displayedComponents: [.date])
                                        .padding(.top,5)
                                        .padding(.bottom,5)
                                }
                                //Finish Date
                                if index == 4 {
                                    DatePicker("", selection: $viewModel.finishDate,displayedComponents: [.date])
                                        .padding(.top,5)
                                        .padding(.bottom,5)
                                }
                            }
                            //Select Another Table Customers
                            else if(viewModel.listViewItems[index]!.type == 6){
                                NavigationLink {
                                        SelectContactsView(
                                            viewModel:viewModel.selectContactsViewModel,
                                            fromNavigation:$fromNaviagation
                                        )
                                        .navigationBarLeadingViewModifier(withTitle: "Contacts", withColor: settingsViewModel.appAppearance)
                                        .navigationBarTitleDisplayMode(.inline)
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
                            }
                            //Τextarea
                            else if(viewModel.listViewItems[index]!.type == 8){
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
            }
            else {
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
        .onAppear{
            if !initialized {
                viewModel.setup(tasksList)
                initialized = true
            }
        }
        .onChange(of: viewModel.showingAlert) { newValue in
            withAnimation {
                showingAlertAnimation = newValue
            }
        }
        .navigationBarHidden(true)
        .frame(maxWidth: .infinity)
        .background(settingsViewModel.appAppearance.themeBackgroundColor)
    }
}
