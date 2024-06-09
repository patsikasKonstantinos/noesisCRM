//
//  NavigationBarLeadingViewModifiers.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 13/8/23.
//

import SwiftUI

struct NavigationBarLeadingViewModifiers: ViewModifier {
    
    //MARK: Variables
    let navigationBartitle: String
    let navigationBackgroundColor: Color
    let mode: ColorScheme
    let appAppearance: AppAppearance

    func body(content: Content) -> some View {
        content
            .navigationTitle(navigationBartitle)
    }
}

extension View {
    
    func navigationBarLeadingViewModifier(withTitle title:String , withColor appAppearance: AppAppearance) -> some View {
         self.modifier(NavigationBarLeadingViewModifiers(navigationBartitle:title,navigationBackgroundColor: appAppearance.themeBackgroundColor,mode:appAppearance.navigationBarTheme[appAppearance] ?? .dark, appAppearance: appAppearance))
    }
}
