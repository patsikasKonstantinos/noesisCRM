//
//  NewDynamicFormView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 22/4/23.
//

import SwiftUI

struct AddNewDynamicFormView: View {
    
    //MARK: Variables
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: AddNewDynamicFormViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @State var showingAlertAnimation = false

    //MARK: Initialization
    init(viewModel: AddNewDynamicFormViewModel) {
        self.viewModel = viewModel
    }

    //MARK: Body
    var body: some View {
        VStack{
            
            if(!showingAlertAnimation){
                List{
                    collectionName()
                    
                    listItems()
                     
                    ZStack {
                        HStack{
                            Text("Add a new field")
                                .fontWeight(.bold)
                            Spacer()
                            Image(systemName: "plus")
                        }
                        
                        Rectangle()
                            .fill(Color.clear)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.addNewField()
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
        .onChange(of: viewModel.showingAlert) { newValue in
            withAnimation {
                showingAlertAnimation = newValue
            }
        }
        .navigationBarLeadingViewModifier(
            withTitle: "Collection Details", withColor: settingsViewModel.appAppearance
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:
             AddNewDynamicFormViewHeader()
                .padding(.vertical,10)
        )
        .frame(maxWidth: .infinity)
        .background(settingsViewModel.appAppearance.themeBackgroundColor)
    }
}

//MARK: Collection Name
extension AddNewDynamicFormView{
    
    func collectionName()-> some View{
        
        HStack{
            Text("Collection Name")
                .foregroundColor(viewModel.filledName ? Color.black.opacity(0.6) : Color.red)
                .font(.system(size: 16))
                .fontWeight(.bold)
                .frame(alignment:.leading)
            
            TextField(
                "",
                text: $viewModel.collectionNameController,
                onEditingChanged: { (isBegin) in
                    //Change Required Fields Colors
                    if isBegin {
                        viewModel.filledName = true
                    }
                }
            )
        }
    }
}
