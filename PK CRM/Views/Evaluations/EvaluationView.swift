//
//  EvaluationView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 7/6/23.
//

import SwiftUI
 
struct EvaluationView: View {
    
    //MARK: Variables
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: EvaluationViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @State var showingAlertAnimation = false
    @State var fromNavigation:Bool = false

    //MARK: Initialization
    init(viewModel: EvaluationViewModel) {
        self.viewModel = viewModel
        viewModel.setup()
    }
     
    //MARK: Body
    var body: some View {
        VStack{
            
            if(!showingAlertAnimation){
                List{
                    ForEach(0..<viewModel.listViewItems.count, id: \.self) { index in
                        
                        let validIndices = viewModel.inputController.indices
                        if validIndices.contains(index) {
                            if viewModel.listViewItems[index]!.type != 12 {
                                HStack{
                                    Text("\(viewModel.listViewItems[index]!.name):")
                                        .foregroundColor(index == 0 && !viewModel.filledTitle || index == 1 && !viewModel.filledUser ? Color.red : Color.black.opacity(0.6))
                                        .font(.system(size: 16))
                                        .frame(width:viewModel.listViewItems[index]!.type == 1 ? 50 : 120,alignment:.leading)
                                        .onAppear{
                                            //Users
                                            if index == 1 {
                                                if(viewModel.selectUsersViewModel.selected.count > 0) {
                                                    viewModel.filledUser = true
                                                }
                                            }
                                        }
                                    
                                    //Date Picket
                                    if(viewModel.listViewItems[index]!.type == 5){
                                        //Date
                                        DatePicker("",
                                            selection: Binding(
                                                get: {viewModel.inputController[index] as? Date ?? Date() },
                                                set: {viewModel.inputController[index] = $0 }
                                            ),
                                            displayedComponents: [.date])
                                            .padding(.top,5)
                                            .padding(.bottom,5)
                                    }
                                    else if(viewModel.listViewItems[index]!.type == 1) {
                                        TextField(
                                            "",
                                            text: $viewModel.title,
                                            onEditingChanged: { (isBegin) in
                                                //Change Required Fields Colors
                                                if isBegin {
                                                    viewModel.filledTitle = true
                                                }
                                            }
                                        )
                                    }
                                    //Τextarea
                                    else if(viewModel.listViewItems[index]!.type == 8){
                                        TextField(
                                            "",
                                            text: Binding(
                                                get: {viewModel.inputController[index] as? String ?? "" },
                                                set: {viewModel.inputController[index] = $0}
                                            ),
                                            axis: .vertical
                                        )
                                        .fixedSize(horizontal: false, vertical: true)
                                        .multilineTextAlignment(.leading)
                                        .padding(10)
                                        .background(Color.black.opacity(0.02))
                                        .cornerRadius(15)
                                    }
                                    //Select Another Table Users
                                    else if(viewModel.listViewItems[index]!.type == 6){
                                        NavigationLink{
                                            SelectContactsView(
                                                viewModel:viewModel.selectUsersViewModel,fromNavigation:$fromNavigation
                                            )
                                            .navigationTitle("\(viewModel.listViewItems[index]!.name)")
                                            .navigationBarLeadingViewModifier(withTitle: "\(viewModel.listViewItems[index]!.name)", withColor: settingsViewModel.appAppearance)
                                            .navigationBarTitleDisplayMode(.inline)
                                            //.navigationBarHidden(true)
                                        } label: {
                                            VStack(alignment: .leading){
                                                if(viewModel.selectUsersViewModel.selected.count > 0) {
                                                    
                                                    ForEach(0..<viewModel.selectUsersViewModel.selected.count, id: \.self){ i in
                                                        if(!viewModel.selectUsersViewModel.selected[i].isInvalidated) {
                                                            Text("\(viewModel.selectUsersViewModel.selected[i].firstName) \(viewModel.selectUsersViewModel.selected[i].surnName)")
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
                                }
                            }
                            //Evaluation
                            if(viewModel.listViewItems[index]!.type == 12){
                                VStack(alignment: .leading){
                                    Text("Evaluation")
                                        .foregroundColor(Color.black.opacity(0.6))
                                        .font(.system(size: 16))
                                        .fontWeight(.bold)
                                        .frame(height:35)

                                    ForEach(Array(viewModel.evaluationCategories), id: \.key){ key, value in
                                        VStack(alignment: .leading) {
                                            Text("\(value)")
                                                .frame(maxWidth: .infinity,alignment:.leading)
                                                .foregroundColor(Color.black.opacity(0.6))
                                                .font(.system(size: 16))
                                                .padding(.vertical,5)
                                                .padding(.leading,5)
                                                .background(Color.blue.opacity(0.05))
 
                                            HStack {
                                                ForEach(1...10, id: \.self) { index in
                                                    Image(systemName: "star.fill")
                                                        .foregroundColor(index <= viewModel.evaluationStars[key] ? .yellow : .black.opacity(0.1))
                                                        .onTapGesture{
                                                            viewModel.setStars(key,index)
                                                         }
                                                }
                                            }
                                            .padding(.top,5)
                                            .padding(.bottom,15)
                                            .padding(.leading,5)
                                        }
                                        .frame(maxWidth: .infinity,alignment:.leading)
                                    }
                                    
                                    HStack{
                                        Text("Overall Performance:")
                                            .foregroundColor(Color.black)
                                            .font(.system(size: 16))
                                            .fontWeight(.bold)
                                            .frame(height:35)
                                        
                                        Text("\(String(format: "%.2f", viewModel.sumEvaluationStars))")
                                            .foregroundColor(Color.black)
                                            .font(.system(size: 16))
                                            .fontWeight(.bold)
                                            .frame(height:35)
                                    }
                                }
                                .frame(maxWidth:.infinity,alignment:.leading)
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
        .onChange(of: viewModel.showingAlert) { newValue in
            withAnimation {
                showingAlertAnimation = newValue
            }
        }
        .background(settingsViewModel.appAppearance.themeBackgroundColor)
        .navigationBarLeadingViewModifier(withTitle: "Performance", withColor: settingsViewModel.appAppearance)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing:EvaluationViewHeader().padding(.vertical,10)
        )
        .onAppear{
            if !fromNavigation{
                viewModel.resetForm()
            }
        }
    }
}
