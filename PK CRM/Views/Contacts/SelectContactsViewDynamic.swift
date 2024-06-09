//
//  SelectContactsViewDynamic.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 31/12/22.
//

import SwiftUI
 

struct SelectContactsViewDynamic: View {
    
    //MARK: Variables
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SelectContactsViewModelDynamic
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @Binding var selectedContacts:[Int:[Contacts]]
    @Binding var fromNavigation:Bool
    @State var showingAlertAnimation = false
    let index:Int
    
    //MARK: Initialization
    init(viewModel: SelectContactsViewModelDynamic,selectedContacts:Binding<[Int: [Contacts]]>,index:Int,fromNavigation:Binding<Bool>) {
        self.viewModel = viewModel
        _selectedContacts = selectedContacts
        self.index = index
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
                               selectedContacts[index] = viewModel.selected
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
        .onAppear{
            viewModel.setup(selectedContacts[index] ?? [])
            fromNavigation = true
        }
        .navigationBarLeadingViewModifier(withTitle: viewModel.contactType == 3 ? "Contacts" : "\(viewModel.types[viewModel.contactType]!)", withColor: settingsViewModel.appAppearance)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(viewModel.allContacts.count > 0 ? .visible : .hidden, for: .navigationBar)
        .toolbarBackground(.white, for: .navigationBar)
        .background(settingsViewModel.appAppearance.themeBackgroundColor)
    }
}
