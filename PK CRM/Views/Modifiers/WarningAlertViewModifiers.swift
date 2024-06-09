//
//  WarningAlertViewModifiers.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 1/6/23.
//

import SwiftUI

struct WarningAlertViewHeight: ViewModifier {
  
    //MARK: Variables
    let scrollable:Bool
    let width:Double
    let height:Double
    
    func body(content: Content) -> some View {
        
        //If content is scrollable or  not
        if !scrollable{
            content
                .frame(width: width, height: height,alignment: .center)

        }else{
            content
                .frame(maxWidth:.infinity,maxHeight:.infinity)
                .frame(alignment: .leading)
                .padding(.horizontal,15)
                .padding(.bottom,15)
        }
    }
}

extension View{
    func viewHeight(scrollable:Bool,width:Double,height:Double)->some View{
        modifier(WarningAlertViewHeight(scrollable:scrollable,width: width,height: height))
    }
}
