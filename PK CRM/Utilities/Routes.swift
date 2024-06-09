//
//  Routes.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 6/8/23.
//

import Foundation

//All App Routes
enum MenuRoutes {
    case economicsKindView,reportsListView,meetingsListView,callsListView,calendarView,goalSettingsListView,evaluationsListView, dynamicFormsListView,syncDataView,settingsView,meetingView,settingsAppearanceView,
        mainTabView
}

enum SettingsRoutes {
    case settingsAppearanceView,mainTabView
}

enum ReportRoutes {
    case economicsReportView,employeeEvaluationsReportView,selectContactsView
}

enum ProjectRoutes {
    case selectContactsView,tasksListView
}

enum MeetingRoutes {
    case selectContactsView
}

enum DynamicCollectionsRoutes {
    case selectContactsView
}
