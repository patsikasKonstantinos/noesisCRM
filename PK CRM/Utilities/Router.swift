//
//  Router.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 7/8/23.
//

import Foundation
import SwiftUI

final class Router: ObservableObject {
    
    public enum Destination: Codable, Hashable {
        case economicsKindView,reportsListView,meetingsListView,callsListView,calendarView,goalSettingsListView,evaluationsListView, dynamicFormsListView,syncDataView,settingsView,meetingView,settingsAppearanceView,
            mainTabView
    }
    
    @Published var navPath = NavigationPath()
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}
