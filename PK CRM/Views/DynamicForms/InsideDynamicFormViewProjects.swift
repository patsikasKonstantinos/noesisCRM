//
//  InsideDynamicFormViewProjects.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 20/6/23.
//

import SwiftUI

extension InsideDynamicFormView {
    
    func insideDynamicFormViewProjects(_ index:Int) -> some View{
 
        NavigationLink{
            SelectProjectsViewDynamic(
                viewModel:viewModel.selectProjectsViewModel,
                selectedProjects:$selectedProjects,index: index,fromNavigation: $fromNavigation
            )
            .navigationBarLeadingViewModifier(withTitle: "Contacts", withColor: settingsViewModel.appAppearance)
            .navigationBarTitleDisplayMode(.inline)
            //.navigationBarHidden(true)
        } label: {
            VStack(alignment: .leading){
                
                if  selectedProjects[index]?.count ?? 0 > 0 {
                    ForEach(0..<selectedProjects[index]!.count,id: \.self){ i in
                        if !selectedProjects[index]![i].isInvalidated {
                            Text("\(selectedProjects[index]![i].code) \(selectedProjects[index]![i].title)")
                                .foregroundColor(.blue)
                                .font(.system(size: 15))
                                .padding(.leading,5)
                            
                            if  selectedProjects[index]![i] != selectedProjects[index]!.last{
                                Divider()
                            }
                        }
                    }
                }
            }
            .onAppear{
                viewModel.inputController[index] = selectedProjects[index] ?? []
            }
            .frame(maxWidth:.infinity,alignment:.leading)
        }
    }
}
