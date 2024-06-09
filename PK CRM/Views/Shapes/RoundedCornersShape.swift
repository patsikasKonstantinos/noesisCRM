//
//  RoundedShape.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 14/3/23.
//

import SwiftUI

struct RoundedCornersShape: Shape {
    
    //MARK: Variables
    let corners: UIRectCorner
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
