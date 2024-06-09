//
//  ContactsImages.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 31/12/22.
//

import SwiftUI

struct ContactsImages: ViewModifier {
  
    //MARK: Properties
    let background:Color

    func body(content: Content) -> some View {
        content
            .frame(width:30,height: 30)
            .scaledToFit()
            .padding(5)
            .background(background)
            .foregroundColor(.white)
            .cornerRadius(5)
            
    }
}

extension Image{
    func contactsImagesStyle(background:Color)->some View{
        modifier(ContactsImages(background:background))
    }
}
