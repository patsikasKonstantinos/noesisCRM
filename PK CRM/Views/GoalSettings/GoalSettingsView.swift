//
//  GoalSettingsView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 1/1/23.
//

import SwiftUI

struct GoalSettingsView: View {
    
    //MARK: Variables
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: GoalSettingsViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @State var showingAlertAnimation = false
    @State var fromNavigation:Bool = false

    //MARK: Initialization
    init(viewModel: GoalSettingsViewModel) {
        self.viewModel = viewModel
        viewModel.setup() // Call the setup function here
    }
    
    //MARK: Body
    var body: some View {
        VStack{
            
            if(!showingAlertAnimation){
                List{
                    ForEach(0..<viewModel.listViewItems.count, id: \.self) { index in
                        HStack{
                            if( index == 0 ) {
                                Text("\(viewModel.listViewItems[index]!.name):")
                                    .foregroundColor(viewModel.filledTitle ? Color.black.opacity(0.6) : Color.red)
                                    .font(.system(size: 16))
                                    .frame(width:50,alignment:.leading)
                                
                            }
                            else{
                                Text("\(viewModel.listViewItems[index]!.name):")
                                    .foregroundColor(Color.black.opacity(0.6))
                                    .font(.system(size: 16))
                                    .frame(width:viewModel.listViewItems[index]!.type == 5 ? 78 : 120,alignment:.leading)
                            }
                            
                            if(viewModel.listViewItems[index]!.type == 1){
                                TextField(
                                    "",
                                    text: $viewModel.inputTextStringsController[index],
                                    onEditingChanged: { (isBegin) in
                                        
                                        //Change Required Fields Colors
                                        if isBegin {
                                            viewModel.filledTitle = true
                                        }
                                    }
                                )
                            }
                            //Date Picket
                            else if(viewModel.listViewItems[index]!.type == 5){
                                //Date
                                DatePicker("", selection: index == 5 ? $viewModel.startDate : $viewModel.endDate,displayedComponents: [.date])
                                //.environment(\.timeZone, TimeZone(secondsFromGMT: 0)!)
                                    .padding(.top,5)
                                    .padding(.bottom,5)
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
                            else if(viewModel.listViewItems[index]!.type == 2){
                                Toggle("", isOn: $viewModel.completed) // 2
                                
                            }
                            else if(viewModel.listViewItems[index]!.type == 9){
                                //Double
                                NumberTextField(text: $viewModel.inputTextStringsController[index])
                            }
                            else if(viewModel.listViewItems[index]!.type == 10){
                                NavigationLink{
                                    SelectProjectsView(viewModel:viewModel.selectProjectsViewModel,fromNavigation:$fromNavigation)
                                    //.navigationBarHidden(true)
                                } label : {
                                    VStack(alignment: .leading){
                                        if(viewModel.selectProjectsViewModel.selected.count > 0){
                                            ForEach(0..<viewModel.selectProjectsViewModel.selected.count,id: \.self){ i in
                                                if(!viewModel.selectProjectsViewModel.selected[i].isInvalidated) {
                                                    Text(viewModel.selectProjectsViewModel.selected[i].code+", "+viewModel.selectProjectsViewModel.selected[i].title)
                                                        .multilineTextAlignment(.center)
                                                        .foregroundColor(.blue)
                                                        .font(.system(size: 15))
                                                        .padding(.leading,5)
                                                }
                                            }
                                        }
                                    }
                                    .frame(maxWidth:.infinity,alignment:.leading)
                                }
                            }
                            else if(viewModel.listViewItems[index]!.type == 11){
                                Picker(selection: $viewModel.typeSelection,
                                       label: Text("")) {
                                    ForEach(0..<viewModel.goalSettingsTypes.count, id: \.self) { typesCount in
                                        Text("\(viewModel.goalSettingsTypes[typesCount]!)").tag(typesCount)
                                    }
                                }
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
           }
           else {
                //ALERT VIEW
                Spacer()
               
                WarningAlertView(
                    showingAlert:$viewModel.showingAlert,
                    text: $viewModel.alertText,
                    title: viewModel.alertTitle,
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
        .navigationBarLeadingViewModifier(
            withTitle: "Details", withColor: settingsViewModel.appAppearance
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing:GoalSettingsViewHeader().padding(.vertical,10)
        )
        .onAppear{
            if !fromNavigation {
                viewModel.resetForm()
            }
        }
    }
}

 

 

 
