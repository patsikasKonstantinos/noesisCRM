//
//  HomePageViewImages.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 18/4/23.
//

import SwiftUI

struct HomePageViewHstacks: ViewModifier {
  
    //MARK: Variables
    let width:CGFloat
    let height:CGFloat?

    func body(content: Content) -> some View {
        content
            .frame( height:height ?? 50, alignment: .leading)
            .padding()
            .cornerRadius(10)
    }
}

struct HomePageViewImages: ViewModifier {
  
    func body(content: Content) -> some View {
        content
            .frame(width:25,height: 25)
            .scaledToFit()
            
    }
}

extension View{
    
    func homePageViewHstackStyle(_ frameWidth:CGFloat,_ frameHeight:CGFloat?) -> some View{
        modifier(HomePageViewHstacks(width:frameWidth,height:frameHeight))
    }
}

extension Image{
    
    func homePageViewImagesStyle() -> some View{
        modifier(HomePageViewImages())
    }
}
