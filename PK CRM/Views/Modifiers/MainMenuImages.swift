//
//  MainMenuImages.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 31/12/22.
//

import SwiftUI

struct MainMenuImages: ViewModifier {
  
    //MARK: Variables
    let background:Color

    func body(content: Content) -> some View {
        content
            .frame(width:35,height: 35)
            .scaledToFit()
            .background(background)
            .foregroundColor(.white)
            .cornerRadius(5)
            
    }
}

extension Image{
    func mainMenuImagesStyle(background:Color)->some View{
        modifier(MainMenuImages(background:background))
    }
}
