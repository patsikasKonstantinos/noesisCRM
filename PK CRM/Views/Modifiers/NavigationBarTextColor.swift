//
//  NavigationBarTextColor.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 6/8/23.
//

import SwiftUI

struct NavigationBarTextColorModifier: ViewModifier {
    
    //MARK: Variables
    let textColor:Color

    func body(content: Content) -> some View {
        content
            .onAppear {
                UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(textColor)]
                UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(textColor)]
            }
    }
}

extension View {
    func setNavigationBarTextColor(viewModel:SettingsViewModel) -> some View {
        let color = viewModel.appAppearance.themeTextColor[viewModel.appAppearance] ?? .black
        return self.modifier(NavigationBarTextColorModifier(textColor: color))
    }
}

 
