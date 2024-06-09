//
//  MainTabViewTabBarAppearance.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 31/12/22.
//

import Foundation
import UIKit
import SwiftUI

extension MainTabView{
    
    func tabBarAppearance(){
        let appearance = UITabBarAppearance()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        appearance.backgroundColor = UIColor(Color.white.opacity(1))
        // Use this appearance when scrolling behind the TabView:
        UITabBar.appearance().standardAppearance = appearance
        // Use this appearance when scrolled all the way up:
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
//        let navigatioBarAppearance = UINavigationBarAppearance()
//        navigatioBarAppearance.shadowColor = .clear // Hide the shadow
//        UIBarButtonItem.appearance().tintColor = .blue
        UIBarButtonItem.appearance().tintColor = settingsViewModel.appAppearance.tintColors[settingsViewModel.appAppearance]
    }
}

extension UIDevice {
    
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isIPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
}
