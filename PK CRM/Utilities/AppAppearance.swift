//
//  AppAppearance.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 3/8/23.
//
import SwiftUI
import Foundation

//App Appearance Colors
enum AppAppearance:Encodable,Decodable {
    case none, darkBlack, lightGray, lightRed, lightBlue, lightGreen, lightOragne
    
    //MARK: Main Background Colors
    var themeBackgroundColor: Color {
       switch self {
           case .none:
               return .clear
           case .darkBlack:
               return Color.black
           case .lightGray:
               return Color.black.opacity(0.05)
           case .lightRed:
               return Color.red.opacity(0.2)
           case .lightBlue:
               return .blue.opacity(0.2)
           case .lightGreen:
               return .green.opacity(0.2)
           case .lightOragne:
               return .orange.opacity(0.2)
       }
   }
    
   //MARK: List Background Colors
   var themesColorsListViewArray:[AppAppearance:Color] {
        var colorsArr:[AppAppearance:Color] = [:]
        colorsArr[.lightGray] = .white
        colorsArr[.darkBlack] = .gray.opacity(0.2)
        colorsArr[.lightRed] = .white
        colorsArr[.lightBlue] = .white
        colorsArr[.lightGreen] = .white
        colorsArr[.lightOragne] = .white
        return colorsArr
    }
     
    //MARK: Color Selection - Setting Page
    var themeBackgroundColorArray:[AppAppearance:Color] {
        var colorsArr:[AppAppearance:Color] = [:]
        colorsArr[.lightGray] = .black.opacity(0.07)
        colorsArr[.darkBlack] = .black
        colorsArr[.lightRed] = .red
        colorsArr[.lightBlue] = .blue
        colorsArr[.lightGreen] = .green
        colorsArr[.lightOragne] = .orange
        return colorsArr
    }
    
    //MARK: Colors of the Titles
    var themesColorsTitlesArray:[AppAppearance:String] {
        var colorsArr:[AppAppearance:String] = [:]
        colorsArr[.lightGray] = "Grey"
        colorsArr[.darkBlack] = "Black"
        colorsArr[.lightRed] = "Red"
        colorsArr[.lightBlue] = "Blue"
        colorsArr[.lightGreen] = "Green"
        colorsArr[.lightOragne] = "Orange"
        return colorsArr
    }
    
    //MARK: Colors of the Text Views
    var themeTextColor:[AppAppearance:Color] {
        var colorsArr:[AppAppearance:Color] = [:]
        colorsArr[.lightGray] = .black
        colorsArr[.darkBlack] = .white
        colorsArr[.lightRed] = .white
        colorsArr[.lightBlue] = .white
        colorsArr[.lightGreen] = .white
        colorsArr[.lightOragne] = .white
        return colorsArr
    }
    
    //MARK: NavigationBars Background Colors
    var navigationBarTheme:[AppAppearance:ColorScheme] {
        var colorsArr:[AppAppearance:ColorScheme] = [:]
        colorsArr[.lightGray] = .light
        colorsArr[.darkBlack] = .dark
        colorsArr[.lightRed] = .dark
        colorsArr[.lightBlue] = .dark
        colorsArr[.lightGreen] = .dark
        colorsArr[.lightOragne] = .light
        return colorsArr
    }
    
    //MARK: Tint Colors of the NavigationBars
    var tintColors:[AppAppearance:UIColor] {
        var colorsArr:[AppAppearance:UIColor] = [:]
        colorsArr[.lightGray] = UIColor(.accentColor)
        colorsArr[.darkBlack] = UIColor(.accentColor)
        colorsArr[.lightRed] = UIColor(.accentColor)
        colorsArr[.lightBlue] = .white
        colorsArr[.lightGreen] = UIColor(.accentColor)
        colorsArr[.lightOragne] = UIColor(.accentColor)
        return colorsArr
        
         
    }
    
    var themeListItemsBackgroundColor:[AppAppearance:Color] {
        var colorsArr:[AppAppearance:Color] = [:]
        colorsArr[.lightGray] = .white
        colorsArr[.darkBlack] = .black.opacity(0.6)
        colorsArr[.lightRed] = .red.opacity(0.6)
        colorsArr[.lightBlue] = .blue.opacity(0.6)
        colorsArr[.lightGreen] = .green.opacity(0.6)
        colorsArr[.lightOragne] = .orange.opacity(0.6)
        return colorsArr
    }
    
    //MARK: List of App Colors Themes Ordered
    var orderedKeys: [AppAppearance] {
         //return [.darkBlack, .lightGray, .lightRed, .lightBlue, .lightGreen, .lightOragne]

//         return [.darkBlack, .lightGray, .lightRed, .lightGreen, .lightOragne]
        
        return [.lightGray, .lightRed, .lightGreen, .lightOragne]
     }
}
