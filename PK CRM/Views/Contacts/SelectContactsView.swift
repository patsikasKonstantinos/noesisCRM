//
//  SelectContactsView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 31/12/22.
//

import SwiftUI
 
struct SelectContactsView: View {
    
    //MARK: Variables
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SelectContactsViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @Binding var fromNavigation:Bool
    @State var showingAlertAnimation = false
    
    //MARK: Initialization
    init(viewModel: SelectContactsViewModel,fromNavigation:Binding<Bool>) {
        self.viewModel = viewModel
        _fromNavigation = fromNavigation

    }

    //MARK: Body
    var body: some View {
        VStack {
            
            if(viewModel.contacts.count>0){
                List{
                    ForEach(viewModel.filteredContacts){
                        contact in
                            Button {
                                viewModel.selected = viewModel.selectContactsAction(contact)
                            } label: {
                                HStack {
                                    Text(contact.firstName+" "+contact.surnName)
                                        .foregroundColor(Color.black)
                                    
                                    Spacer()
                                    
                                    if viewModel.isSelected(contact) {
                                        Image(systemName: "checkmark")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width:15,height:15)
                                            .padding(.leading,5)
                                    }else{
                                        Spacer()
                                            .frame(width:15,height:15)
                                            .padding(.leading,5)
                                    }
                                }
                            }
                    }
                    .listRowBackground(Color.white)
                }
                .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
                .scrollContentBackground(.hidden)
            }else{
                Spacer()
                
                Text(viewModel.contactType == 3 ? "Contacts Not Found" : "\(viewModel.types[viewModel.contactType]!) Not Found")
                    .frame(maxWidth:.infinity)
                
                Spacer()
            }
        }
        .navigationBarLeadingViewModifier(withTitle: viewModel.contactType == 3 ? "Contacts" : "\(viewModel.types[viewModel.contactType]!)", withColor: settingsViewModel.appAppearance)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(viewModel.allContacts.count > 0 ? .visible : .hidden, for: .navigationBar)
        .toolbarBackground(.white, for: .navigationBar)
        .onAppear{
            //navigationView = true
            fromNavigation = true
         }
        .background(settingsViewModel.appAppearance.themeBackgroundColor)
    }
}
