//
//  MainTabView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 31/12/22.
//

import SwiftUI

struct MainTabView: View {
    
    //MARK: Variables
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @ObservedObject private var contactsListViewModel:ContactsListViewModel
    @ObservedObject private var projectsListViewModel:ProjectsListViewModel
    @ObservedObject private var meetingsListViewModel:MeetingsListViewModel
    @ObservedObject private var callsListViewModel:CallsListViewModel
    @ObservedObject private var goalSettingsListViewModel:GoalSettingsListViewModel
    @ObservedObject private var calendarViewModel:CalendarViewModel
    @ObservedObject private var evaluationsListViewModel:EvaluationsListViewModel
    @ObservedObject private var dynamicFormsListViewModel:DynamicFormsListViewModel
    @ObservedObject private var syncDataViewModel:SyncDataViewModel
    @ObservedObject private var reportsViewModel:ReportsViewModel
    private var contactsFunctionality = ContactsFunctionality()
    private var projectsFunctionality = ProjectsFunctionality()
    private var meetingsFunctionality = MeetingsFunctionality()
    private var callsFunctionality = CallsFunctionality()
    private var goalSettingsFunctionality = GoalSettingsFunctionality()
    private var daysOffFunctionality = DaysOffFunctionality()
    private var evalluationsFunctionality = EvaluationsFunctionality()
    private var dynamicFormsFunctionality = DynamicFormsFunctionality()
    private var servicesObj = Services()
    
    //MARK: Initialization
    init() {
        contactsListViewModel = ContactsListViewModel(contactsFunctionality: contactsFunctionality)
        projectsListViewModel = ProjectsListViewModel(projectsFunctionality: projectsFunctionality)
        meetingsListViewModel = MeetingsListViewModel(meetingsFunctionality: meetingsFunctionality)
        callsListViewModel = CallsListViewModel(callsFunctionality: callsFunctionality)
        goalSettingsListViewModel = GoalSettingsListViewModel(goalSettingsFunctionality: goalSettingsFunctionality)
        calendarViewModel = CalendarViewModel(daysOffFunctionality: daysOffFunctionality)
        evaluationsListViewModel = EvaluationsListViewModel(evaluationsFunctionality: evalluationsFunctionality)
        dynamicFormsListViewModel = DynamicFormsListViewModel(dynamicFormsFunctionality: dynamicFormsFunctionality)
        syncDataViewModel = SyncDataViewModel(serviceObj:servicesObj)
        reportsViewModel = ReportsViewModel()

    }
     
    //MARK: Body
    var body: some View {
        TabView{
            HomeScreenView()
                .tabItem{
                    Image(systemName: "house")
                        .mainTabViewImagesStyle()
                    Spacer()
                    Text("Home")
                }

            ContactsListView(viewModel: contactsListViewModel)
                .tabItem {
                    Image(systemName: "person")
                        .mainTabViewImagesStyle()
                    Text("Contacts")
                }
            
            ProjectsListView(viewModel: projectsListViewModel)
                .tabItem {
                    Image(systemName: "pencil.slash")
                        .mainTabViewImagesStyle()
                    Text("Projects")
                }
            
            MainMenuView(
                    contactsListViewModel:contactsListViewModel,
                    projectsListViewModel:projectsListViewModel,
                    meetingsListViewModel:meetingsListViewModel,
                    callsListViewModel:callsListViewModel,
                    goalSettingsListViewModel:goalSettingsListViewModel,
                    calendarViewModel:calendarViewModel,
                    evaluationsListViewModel:evaluationsListViewModel,
                    dynamicFormsListViewModel:dynamicFormsListViewModel,
                    syncDataViewModel:syncDataViewModel,
                    reportsViewModel: reportsViewModel
                )
                .tabItem{
                    Image(systemName: "line.3.horizontal")
                        .mainTabViewImagesStyle()
                    Text("Menu")
                }
        }
        .padding(.top,5)
        .onAppear() {
            tabBarAppearance()
        }
    }
}

