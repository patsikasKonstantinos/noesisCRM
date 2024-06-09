//
//  GradientBackgroundView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 29/8/23.
//

import SwiftUI

struct GradientBackgroundView: View {
    
    //MARK: Variables
    let color:Color
    let points:(startPoint: UnitPoint, endPoint: UnitPoint)
    
    //MARK: Body
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [color.opacity(0.5), color]),
            startPoint: points.startPoint,
            endPoint: points.endPoint
        )
        .cornerRadius(10)
        .edgesIgnoringSafeArea(.all)
    }
}

 
