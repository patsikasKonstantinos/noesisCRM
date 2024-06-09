//
//  SettingsView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 3/8/23.
//

import SwiftUI

struct SettingsView: View {
    
    //MARK: Variables
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    //MARK: Body
    var body: some View {
        
        VStack{
            List{
                NavigationLink {
                    SettingsAppearanceView()
                } label: {
                    HStack{
                        Image(systemName: "paintbrush.fill")
                            .mainMenuImagesStyle(background: .purple)
                        Text("Appearance")
                    }
                }
                
                NavigationLink{
                    SettingsMenuCustomizationView()
                } label: {
                    HStack{
                        Image(systemName: "filemenu.and.selection")
                            .mainMenuImagesStyle(background: .orange)
                        Text("Menu Customization")
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(settingsViewModel.appAppearance.themeBackgroundColor)
        }
        .navigationBarLeadingViewModifier(
            withTitle: "Settings",
            withColor: settingsViewModel.appAppearance
        )
        .navigationBarTitleDisplayMode(.large)
 
    }
}

 
