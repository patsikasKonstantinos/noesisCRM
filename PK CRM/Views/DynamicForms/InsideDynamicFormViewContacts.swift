//
//  InsideDynamicFormViewContacts.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 20/6/23.
//

import SwiftUI

extension InsideDynamicFormView{
    
    func insideDynamicFormViewContacts(_ index:Int) -> some View{
    
        NavigationLink{
            SelectContactsViewDynamic(
                viewModel:viewModel.selectContactsViewModel,
                selectedContacts:$selectedContacts,index: index,fromNavigation: $fromNavigation
            )
            .navigationBarLeadingViewModifier(withTitle: "Contacts", withColor: settingsViewModel.appAppearance)
            .navigationBarTitleDisplayMode(.inline)
            //.navigationBarHidden(true)
        } label: {
            VStack(alignment: .leading){

                if  selectedContacts[index]?.count ?? 0 > 0 {
                    ForEach(0..<selectedContacts[index]!.count,id: \.self){ i in
                        
                        if !selectedContacts[index]![i].isInvalidated {
                            Text("\(selectedContacts[index]![i].firstName) \(selectedContacts[index]![i].surnName)")
                                .foregroundColor(.blue)
                                .font(.system(size: 15))
                                .padding(.leading,5)
                            
                            if  selectedContacts[index]![i] != selectedContacts[index]!.last {
                                Divider()
                            }
                        }
                    }
                }
            }
            .onAppear{
                viewModel.inputController[index] = selectedContacts[index] ?? []
            }
            .frame(maxWidth:.infinity,alignment:.leading)
        }
    }
}
