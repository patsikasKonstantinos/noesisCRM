//
//  SettingsMenuCustomization.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 25/8/23.
//

import SwiftUI

struct SettingsMenuCustomizationView: View {
    
    //MARK: Variables
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    //MARK: Body
    var body: some View {
        VStack{
            List {
                HStack{
                    Image(systemName: "dollarsign")
                        .mainMenuImagesStyle(background: AppColors.greenOpacity06.swiftUIColor)

                    Text(Variables.mainMenuListNames[0]!)
                    
                    Spacer()
                    
                    Toggle("", isOn: Binding(
                        get: {settingsViewModel.activeMenu[AppMenu.economics] ?? false},
                        set: {settingsViewModel.activeMenu[AppMenu.economics] = $0 }
                    ))
                }
                
                HStack{
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .mainMenuImagesStyle(background: AppColors.blueOpacity06.swiftUIColor)
                    
                    Text(Variables.mainMenuListNames[1]!)
                    
                    Spacer()
                    
                    Toggle("", isOn: Binding(
                        get: {settingsViewModel.activeMenu[AppMenu.reports] ?? false},
                        set: {settingsViewModel.activeMenu[AppMenu.reports] = $0 }
                    ))
                    
                }
                
                HStack{
                    Image(systemName: "person.line.dotted.person.fill")
                        .mainMenuImagesStyle(background: .orange)

                    Text(Variables.mainMenuListNames[3]!)
                    
                    Spacer()
                    
                    Toggle("", isOn: Binding(
                        get: {settingsViewModel.activeMenu[AppMenu.meetings] ?? false},
                        set: {settingsViewModel.activeMenu[AppMenu.meetings] = $0 }
                    ))
                }
                
                HStack{
                    Image(systemName: "phone.fill")
                        .mainMenuImagesStyle(background: .red)

                    Text(Variables.mainMenuListNames[4]!)
                    
                    Spacer()
                    
                    Toggle("", isOn: Binding(
                        get: {settingsViewModel.activeMenu[AppMenu.calls] ?? false},
                        set: {settingsViewModel.activeMenu[AppMenu.calls] = $0 }
                    ))
                }
                
                HStack{
                    Image(systemName: "calendar")
                        .mainMenuImagesStyle(background: .indigo)

                    Text(Variables.mainMenuListNames[5]!)
                    
                    Spacer()
                    
                    Toggle("", isOn: Binding(
                        get: {settingsViewModel.activeMenu[AppMenu.daysOff] ?? false},
                        set: {settingsViewModel.activeMenu[AppMenu.daysOff] = $0 }
                    ))
                }
                
                HStack{
                    Image(systemName: "target")
                        .mainMenuImagesStyle(background: .brown)

                    Text(Variables.mainMenuListNames[6]!)
                    
                    Spacer()
                    
                    Toggle("", isOn: Binding(
                        get: {settingsViewModel.activeMenu[AppMenu.goalSettings] ?? false},
                        set: {settingsViewModel.activeMenu[AppMenu.goalSettings] = $0 }
                    ))
                }
                
                HStack{
                    Image(systemName: "star.fill")
                        .mainMenuImagesStyle(background: AppColors.greenOpacity06.swiftUIColor)

                    Text(Variables.mainMenuListNames[7]!)
                    
                    Spacer()
                    
                    Toggle("", isOn: Binding(
                        get: {settingsViewModel.activeMenu[AppMenu.evaluations] ?? false},
                        set: {settingsViewModel.activeMenu[AppMenu.evaluations] = $0 }
                    ))
                }
                
                HStack{
                    
                    Image(systemName: "text.and.command.macwindow")
                        .mainMenuImagesStyle(background: .purple)

                    Text(Variables.mainMenuListNames[10]!)
                    
                    Spacer()
                    
                    Toggle("", isOn: Binding(
                        get: {settingsViewModel.activeMenu[AppMenu.customCullections] ?? false},
                        set: {settingsViewModel.activeMenu[AppMenu.customCullections] = $0 }
                    ))
                }
            }
        }
        .navigationBarLeadingViewModifier(
            withTitle: "Menu Customization",
            withColor: settingsViewModel.appAppearance
        )
        .scrollContentBackground(.hidden)
        .background(settingsViewModel.appAppearance.themeBackgroundColor)
        .onChange(of:settingsViewModel.activeMenu){ newValue in
            settingsViewModel.setAppActiveMenu(newValue)
            
        }
    }
}

 
