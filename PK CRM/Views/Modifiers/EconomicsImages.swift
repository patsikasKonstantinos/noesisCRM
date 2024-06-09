//
//  EconomicsImages.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 31/12/22.
//

import SwiftUI

struct EconomicsImages: ViewModifier {
  
    //MARK: Properties
    let background:Color

    func body(content: Content) -> some View {
        content
            .frame(width:30,height: 30)
            .padding(2)
            .scaledToFit()
            .background(background)
            .foregroundColor(.white)
            .cornerRadius(5)
            
    }
}

extension Image{
    func economicsImagesStyle(background:Color)->some View{
        modifier(EconomicsImages(background:background))
    }
}
