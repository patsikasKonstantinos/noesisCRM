//
//  AppColors.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 13/6/23.
//

import Foundation
import SwiftUI
 
enum AppColors {
    case yellowOpacity06, orangeOpacity06, greenOpacity06, redOpacity06 , redOpacity03 ,orangeOpacity03, orangeOpacity04,greenOpacity03, purpleOpacity03, yellowOpacity03,blueOpacity03,blueOpacity06,brownOpacity06,
         brownOpacity03,brownOpacity02,indigoOpacity02, black, gray ,aqua,clear
 
    //MARK: Colors
    var swiftUIColor: Color {
       switch self {
           case .yellowOpacity06:
               return Color.yellow.opacity(0.6)
           case .orangeOpacity06:
               return Color.orange.opacity(0.6)
           case .orangeOpacity04:
               return Color.orange.opacity(0.4)
           case .greenOpacity06:
               return Color.green.opacity(0.6)
           case .redOpacity06:
               return Color.red.opacity(0.6)
           case .orangeOpacity03:
               return .orange.opacity(0.3)
           case .greenOpacity03:
               return .green.opacity(0.3)
           case .purpleOpacity03:
               return .purple.opacity(0.3)
           case .yellowOpacity03:
               return .yellow.opacity(0.3)
           case .redOpacity03:
               return Color.red.opacity(0.3)
           case .blueOpacity03:
               return  .blue.opacity(0.3)
           case .blueOpacity06:
               return  .blue.opacity(0.6)
           case .brownOpacity06:
               return  .brown.opacity(0.6)
           case .brownOpacity03:
               return  .brown.opacity(0.3)
           case .brownOpacity02:
               return  .brown.opacity(0.2)
           case .indigoOpacity02:
                return .indigo.opacity(0.2)
           case .black:
               return .black
           case .gray:
               return .gray
           case .aqua:
                return Color(red: 180/255, green: 254/255, blue: 231/255)
           case .clear:
               return .clear
       }
   }
}
