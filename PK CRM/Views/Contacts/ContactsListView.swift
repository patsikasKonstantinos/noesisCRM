import SwiftUI
 
struct ContactsListView: View {
    
    //MARK: Variables
    @ObservedObject var viewModel: ContactsListViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    //MARK: Initialization
    init(viewModel: ContactsListViewModel) {
        self.viewModel = viewModel
    }
    
    //MARK: Body
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.filteredContacts.count > 0 {
                    List {
                        ForEach(Array(viewModel.filteredContacts.enumerated()), id: \.1.id) { index, contact in
                            ZStack{
                                NavigationLink{
                                    ContactView(viewModel: ContactViewModel(contactId: contact.id, newContact:false,initPaymentsList:true,contactTypeFilter:nil),allPaymentsList: [],initialized:false)
                               } label: {
                                   HStack{
                                       
                                       if contact.type == 0 {
                                           Image("customer")
                                               .resizable()
                                               .contactsImagesStyle(background: AppColors.greenOpacity06.swiftUIColor)
                                       }
                                       else if contact.type == 1 {
                                           Image("businessman")
                                               .resizable()
                                               .contactsImagesStyle(background: .orange)
                                       }
                                       else{
                                           Image("supplier")
                                               .resizable()
                                               .contactsImagesStyle(background: .red)
                                       }
                                       
                                       Text("\(contact.firstName) \(contact.surnName)")
                                           .foregroundColor(Color.black)
                                   }
                                    
                               }
                            }
                        }
                        .onDelete(perform:viewModel.deleteContacts)
                    }
                    .frame(maxWidth: .infinity)
                    .scrollContentBackground(.hidden)
                    
                  } else {
                    Text("Contacts Not Found")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    ContactsListViewFilters()
                        .background(settingsViewModel.appAppearance.themeBackgroundColor)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchText, placement:
                    .navigationBarDrawer(displayMode: .always))
            .navigationBarItems(trailing:
                    NavigationLink{
                        ContactView(viewModel: ContactViewModel(contactId: nil, newContact:true,initPaymentsList:true,contactTypeFilter:viewModel.selectedContactType),allPaymentsList: [],initialized:false)
                    } label: {
                        Text("Add")
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                            .padding(.vertical, 10)
                    }
            )
            .background(settingsViewModel.appAppearance.themeBackgroundColor)
            .onAppear {
                viewModel.updateListId()
            }
        }
    }
}
