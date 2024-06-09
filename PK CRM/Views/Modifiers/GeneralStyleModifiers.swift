//
//  GeneralStyleModifiers.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 26/8/23.
//

import SwiftUI

struct InfinityLeading: ViewModifier {
  
    func body(content: Content) -> some View {
        content
            .frame(maxWidth:.infinity,alignment:.leading)
    }
}

struct HomePageProjects:ViewModifier {
   
    //MARK: Variables
    let width:CGFloat
    
    func body(content: Content) -> some View {
        content
            .frame(width: width,height: 210)
            .cornerRadius(10)
    }
}

struct WhiteBackgroundWithRadius:ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background(.white)
            .cornerRadius(10)
    }
}

extension View{
    
    func infinityLeading()->some View{
        modifier(InfinityLeading())
    }
    
    func whiteBackgroundWithRadius()->some View{
        modifier(WhiteBackgroundWithRadius())
    }
    
    func homePageProjects(width:CGFloat)->some View{
        modifier(HomePageProjects(width:width))
    }
}
