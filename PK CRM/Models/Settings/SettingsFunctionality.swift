//
//  SettingsFunctionality.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 4/8/23.
//

import Foundation

class SettingsFunctionality{
    
    //MARK: Properties
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    //MARK: Functions
    func getAppAppearance() -> AppAppearance {
        var themeColor:AppAppearance = .lightGray
        // Read the data from file
        if let savedData = try? Data(contentsOf: Variables.themeColorFileManagereURL) {
             
            // Decode the data back into a custom object
            if let decodedObject = try? self.decoder.decode(AppAppearance.self, from: savedData) {
                themeColor = decodedObject
            }
        }
        return themeColor
    }
    
    func setAppAppearance(_ theme:AppAppearance)  {
        if let encodedData = try? encoder.encode(theme) {
            do {
                try encodedData.write(to: Variables.themeColorFileManagereURL)
            } catch {
                print("Failed to write data to file: \(error)")
            }
        }
    }
    
    func setAppActiveMenu(_ menu:[AppMenu:Bool]) {
        if let encodedData = try? encoder.encode(menu) {
            do {
                try encodedData.write(to: Variables.activeMenuFileManagereURL)
            } catch {
                print("Failed to write data to file: \(error)")
            }
        }
    }
    
    func getAppActiveMenu() ->[AppMenu:Bool] {
        var activeMenu:[AppMenu:Bool] = [
            .economics:true,
            .reports:true,
            .meetings:true,
            .calls:true,
            .daysOff:true,
            .goalSettings:true,
            .evaluations:true,
            .customCullections:true
        ]
        
        if let savedData = try? Data(contentsOf: Variables.activeMenuFileManagereURL) {
            // Decode the data back into a custom object
            if let decodedObject = try? self.decoder.decode([AppMenu: Bool].self, from: savedData) {
                activeMenu = decodedObject
            }
        }
        return activeMenu
    }
}
