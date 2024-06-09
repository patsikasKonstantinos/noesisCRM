//
//  AlertView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 23/1/23.
//

import Foundation
import SwiftUI

struct WarningAlertView: View {
    
    //MARK: Variables
    @Binding var showingAlert:Bool
    @Binding var text:String
    var title:String
    var width:Double
    var height:Double
    var scrollable:Bool
    
    //MARK: Body
    var body: some View {
        VStack{
            Image(systemName: "clear.fill")
                .resizable()
                .foregroundColor(.red)
                .frame(width: 70,height: 70)
                .cornerRadius(50)
                .padding(15)
              
            Text("\(title)")
                .multilineTextAlignment(.center)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.red)
                .tracking(1.4)
                .padding(.leading,15)
                .padding(.trailing,15)
         
            if scrollable {
                ScrollView(showsIndicators: false){
                    Text("\(text)")
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true) // Enable multiline
                        .padding(.leading,5)
                        .padding(.trailing,15)
                        .padding(.top,5)
                        .padding(.bottom,45)
                }
            }
            else{
                Text("\(text)")
                     .multilineTextAlignment(.center)
                     .fixedSize(horizontal: false, vertical: true) // Enable multiline support
                     .padding()
            }
            
            Text("Close")
                .font(.system(size: 18))
                .foregroundColor(.blue)
                .frame(maxWidth:.infinity)
                .frame(height:50)
                .background(.gray.opacity(0.01))
                .overlay(
                    Rectangle()
                        .frame(height: 1) // Adjust the height of the border as needed
                        .foregroundColor(.gray.opacity(0.2)) // Adjust the border color as needed
                        .padding(.top, -25)
                )
                .onTapGesture {
                      withAnimation{
                          showingAlert = false
                      }
                }
        }
        .background(.white)
        .cornerRadius(5)
        .transition(.scale)
        .cornerRadius(10)
        .viewHeight(scrollable: scrollable, width: width, height: height)
     }
}
