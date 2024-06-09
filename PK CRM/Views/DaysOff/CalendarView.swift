//
//  CalendarView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 16/6/23.
//

import SwiftUI

struct CalendarView: View {
    
    //MARK: Variables
    @ObservedObject private var viewModel: CalendarViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    //MARK: Initialization
    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
    }
    
    //MARK: Body
    var body: some View {
        VStack{
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    CalendarContentView(viewModel: viewModel,geometry: geometry)
                }
            }
            .frame(maxWidth:600,maxHeight: .infinity, alignment: .top)
            .navigationBarLeadingViewModifier(
                withTitle: "Days Off", withColor: settingsViewModel.appAppearance
            )
            .navigationBarTitleDisplayMode(.inline)
        }
        .frame(maxWidth:.infinity)
        .background(settingsViewModel.appAppearance.themeBackgroundColor)
    }
}
