//
//  MainTabViewImages.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 31/12/22.
//

import SwiftUI

struct MainTabViewImages: ViewModifier {
  
    func body(content: Content) -> some View {
        content
            .frame(width:50,height: 50)
            .scaledToFit()
    }
}

extension Image{
    
    func mainTabViewImagesStyle()->some View{
        modifier(MainTabViewImages())
    }
}
