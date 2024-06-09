//
//  CalendarDayView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 26/8/23.
//

import SwiftUI

struct CalendarDayView: View {
    
    //MARK: Variables
    let date:Date
    
    //MARK: Body
    var body: some View {
        VStack(spacing:0){
            Text("Day")
                .frame(maxWidth:.infinity)
                .foregroundColor(.white)
                .background(
                    RoundedCornersShape(corners: [.topRight,.topLeft], radius: 5)
                        .fill(.orange)
                )
            
            VStack{
                Text("\(date.day)")
                    .foregroundColor(.gray)
                
                Text("\(date.dayName)")
                    .foregroundColor(.gray)
            }
            .frame(width:50)
            .padding(.vertical,5)
        }
        .frame(width:50)
        .background(
            RoundedCornersShape(corners: [.bottomRight,.bottomLeft], radius: 5)
                .fill(Color.orange.opacity(0.1))
        )
    }
}
