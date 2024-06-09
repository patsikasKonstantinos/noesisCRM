//
//  SettingsAppearanceView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 4/8/23.
//

import SwiftUI

struct SettingsAppearanceView: View {
    
    //MARK: Variables
    @EnvironmentObject var settingsViewModel: SettingsViewModel
 
    //MARK: Body
    var body: some View {
        VStack{
            List{
                ForEach(settingsViewModel.appAppearance.orderedKeys, id: \.self) {
                    appearance in
                    ZStack {
                        HStack {
                            ZStack{}
                                 
                                .frame(width:30,height: 30)
                                .background(settingsViewModel.appAppearance.themeBackgroundColorArray[appearance])
                                .cornerRadius(5)
     
                            Text("\(settingsViewModel.appAppearance.themesColorsTitlesArray[appearance] ?? "" )")
                                
                            Spacer()
                            
                            if settingsViewModel.appAppearance == appearance {
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width:15,height:15)
                                    .foregroundColor(.accentColor)
                                     
                            }else{
                                ZStack{}
                                    .frame(width:15,height:15)
                            }
                        }
                        
                        Rectangle()
                            .fill(Color.clear)
                            .contentShape(Rectangle())
                    }
                    .onTapGesture {
                        settingsViewModel.setAppAppearance(appearance)
                    }
                }
                .listRowBackground(settingsViewModel.appAppearance.themesColorsListViewArray[settingsViewModel.appAppearance])
            }
            .scrollContentBackground(.hidden)
            .background(settingsViewModel.appAppearance.themeBackgroundColor)
        }
        .navigationTitle("Appearance")
        .navigationBarLeadingViewModifier(
            withTitle: "Appearance", withColor: settingsViewModel.appAppearance
        )
        .navigationBarTitleDisplayMode(.large)
 
    }
}

 
