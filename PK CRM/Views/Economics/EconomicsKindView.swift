//
//  EconomicsView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 28/2/23.
//

import SwiftUI

struct EconomicsKindView: View {

    //MARK: Variables
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    //MARK: Body
    var body: some View {
            List{
                NavigationLink{
                    EconomicsListView(
                        viewModel: EconomicsListViewModel(
                            income: true,
                            expenses: false 
                         )
                    )
                } label: {
                    HStack(alignment: .center){
                        Image("income")
                            .resizable()
                            .economicsImagesStyle(background: AppColors.greenOpacity06.swiftUIColor)

                        Text("Incomes")
                           
                    }
                }
                
                NavigationLink{
                    EconomicsListView(
                        viewModel: EconomicsListViewModel(
                            income: false,
                            expenses: true
                         )
                    )
                } label: {
                    HStack(alignment: .center){
                        Image("expenses")
                            .resizable()
                            .economicsImagesStyle(background: .red)

                            Text("Expenses")
                    }
                   
                }
            }
            .scrollContentBackground(.hidden)
            .background(settingsViewModel.appAppearance.themeBackgroundColor)
            .navigationBarLeadingViewModifier(
                withTitle: "Financial Economics", withColor: settingsViewModel.appAppearance
            )
    }
}
