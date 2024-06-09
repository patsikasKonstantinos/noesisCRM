//
//  AppMenu.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 25/8/23.
//

import Foundation
 
//Main Menu Items
enum AppMenu:Encodable,Decodable {
    case economics, reports, contacts, meetings, calls, daysOff, goalSettings,evaluations,projects,tasks,customCullections,sync,settings
}
