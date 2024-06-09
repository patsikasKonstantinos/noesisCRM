//
//  MainMenuView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 31/12/22.
//

import SwiftUI

struct MainMenuView: View {

    //MARK: Properties
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    var contactsListViewModel:ContactsListViewModel
    var projectsListViewModel:ProjectsListViewModel
    var meetingsListViewModel:MeetingsListViewModel
    var callsListViewModel:CallsListViewModel
    var goalSettingsListViewModel:GoalSettingsListViewModel
    var calendarViewModel:CalendarViewModel
    var evaluationsListViewModel:EvaluationsListViewModel
    var dynamicFormsListViewModel:DynamicFormsListViewModel
    var syncDataViewModel:SyncDataViewModel
    var reportsViewModel:ReportsViewModel

    //MARK: Initialization
    init(contactsListViewModel:ContactsListViewModel,
     projectsListViewModel:ProjectsListViewModel,
     meetingsListViewModel:MeetingsListViewModel,
     callsListViewModel:CallsListViewModel,
     goalSettingsListViewModel:GoalSettingsListViewModel,
     calendarViewModel:CalendarViewModel,
     evaluationsListViewModel:EvaluationsListViewModel,
     dynamicFormsListViewModel:DynamicFormsListViewModel,
     syncDataViewModel:SyncDataViewModel,
     reportsViewModel:ReportsViewModel
    ) {
        self.contactsListViewModel = contactsListViewModel
        self.projectsListViewModel = projectsListViewModel
        self.meetingsListViewModel = meetingsListViewModel
        self.callsListViewModel = callsListViewModel
        self.goalSettingsListViewModel = goalSettingsListViewModel
        self.calendarViewModel = calendarViewModel
        self.evaluationsListViewModel = evaluationsListViewModel
        self.dynamicFormsListViewModel = dynamicFormsListViewModel
        self.syncDataViewModel = syncDataViewModel
        self.reportsViewModel = reportsViewModel
    }

    //MARK: Body
    var body: some View {
        NavigationStack {
            List{
                Section{
                    if settingsViewModel.activeMenu[.economics] ?? true {
                        
                        NavigationLink{
                            EconomicsKindView()
                        } label: {
                            HStack{
                                Image(systemName: "dollarsign")
                                    .mainMenuImagesStyle(background: AppColors.greenOpacity06.swiftUIColor)
                                   
                                Text(Variables.mainMenuListNames[0]!)
                            }
                        }
     
                    }
                    
                    if settingsViewModel.activeMenu[.reports] ?? true {
                        NavigationLink{
                            ReportsListView(viewModel: reportsViewModel)
                        } label: {
                            HStack{
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .mainMenuImagesStyle(background:AppColors.blueOpacity06.swiftUIColor)
                                
                                Text(Variables.mainMenuListNames[1]!)
                            }
                        }
                    }
                }
                
                Section{

                    if settingsViewModel.activeMenu[.meetings] ?? true {
                        NavigationLink{
                            MeetingsListView(viewModel:meetingsListViewModel)
                        } label: {
                            HStack{
                                Image(systemName: "person.line.dotted.person.fill")
                                    .mainMenuImagesStyle(background: .orange)

                                Text(Variables.mainMenuListNames[3]!)
                            }
                        }
                    }
                     
                    if settingsViewModel.activeMenu[.calls] ?? true {
                        
                        NavigationLink{
                            CallsListView(viewModel:callsListViewModel)
                        } label: {
                            HStack{
                                Image(systemName: "phone.fill")
                                    .mainMenuImagesStyle(background: .red)

                                Text(Variables.mainMenuListNames[4]!)
                            }
                        }
                    }
                    
                    if settingsViewModel.activeMenu[.daysOff] ?? true {
                        
                        NavigationLink{
                            CalendarView(viewModel: calendarViewModel)
                        } label: {
                            HStack{
                                Image(systemName: "calendar")
                                    .mainMenuImagesStyle(background: .indigo)

                                Text(Variables.mainMenuListNames[5]!)
                            }
                        }
                    }
                }
                
                Section{
                    
                    if settingsViewModel.activeMenu[.goalSettings] ?? true {
                        
                        NavigationLink{
                            GoalSettingsListView(viewModel: goalSettingsListViewModel)
                        } label: {
                            HStack{
                                Image(systemName: "target")
                                    .mainMenuImagesStyle(background: .brown)

                                Text(Variables.mainMenuListNames[6]!)
                            }
                        }
                    }
                        
                    if settingsViewModel.activeMenu[.evaluations] ?? true {
                        
                        NavigationLink{
                            EvaluationsListView(viewModel: evaluationsListViewModel)
                        } label: {
                            HStack{
                                Image(systemName: "star.fill")
                                    .mainMenuImagesStyle(background: AppColors.greenOpacity06.swiftUIColor)

                                Text(Variables.mainMenuListNames[7]!)
                            }
                        }
                    }
                }
                
                Section{
                    
                    if settingsViewModel.activeMenu[.customCullections] ?? true {
                        NavigationLink{
                            DynamicFormsListView(viewModel: dynamicFormsListViewModel)
                        } label: {
                            HStack{
                                Image(systemName: "text.and.command.macwindow")
                                    .mainMenuImagesStyle(background: .purple)

                                Text(Variables.mainMenuListNames[10]!)
                            }
                        }
                    }
                }
                
                Section{
                    NavigationLink{
                        SyncDataView(viewModel: syncDataViewModel)
                    } label: {
                        HStack{
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .mainMenuImagesStyle(background: .orange)

                            Text(Variables.mainMenuListNames[11]!)
                        }
                    }
                    
                    NavigationLink{
                        SettingsView()
                    } label: {
                        HStack{
                            Image(systemName: "gearshape")
                                .mainMenuImagesStyle(background: .gray)

                            Text(Variables.mainMenuListNames[12]!)
                        }
                    }
                }
            }
             .navigationBarLeadingViewModifier(withTitle: "Menu", withColor: settingsViewModel.appAppearance)
            .scrollContentBackground(.hidden)
            .background(settingsViewModel.appAppearance.themeBackgroundColor)
        }
     }
}

