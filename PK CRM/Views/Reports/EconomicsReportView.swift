//
//  EconomicsReportView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 27/7/23.
//

import SwiftUI

struct EconomicsReportView: View {
    
    //MARK: Variables
    @ObservedObject var viewModel: ReportsViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    //MARK: Initialization
    init(viewModel: ReportsViewModel) {
        self.viewModel = viewModel
    }
    
    //MARK: Body
    var body: some View {
        VStack{
            EconomicsChartView(viewModel:viewModel)
        }
        .frame(maxWidth:.infinity,alignment: .center)
        .navigationBarItems(
            trailing:
                Text("Filters")
                .foregroundColor(.blue)
                .fontWeight(.bold)
                .padding(.vertical, 10)
                .onTapGesture {
                    viewModel.showFilters.toggle()
                }
                .sheet(isPresented: $viewModel.showFilters,onDismiss:{}) {
                   EconomicsReportViewFilters(viewModel: viewModel)
               }
        )
        //.navigationTitle("Economics")
        .navigationBarLeadingViewModifier(withTitle: "Economics", withColor: settingsViewModel.appAppearance)
        .navigationBarTitleDisplayMode(.inline)
        .background(settingsViewModel.appAppearance.themeBackgroundColor)
    }
}

 
