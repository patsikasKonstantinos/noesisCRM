//
//  AlertView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 23/1/23.
//

import SwiftUI

struct SuccesslertView: View {
    
    //MARK: Variables
    @Binding var showingAlert:Bool
    var title:String
    var text:String
    var width:Double
    var height:Double
     
    //MARK: Body
    var body: some View {
        VStack{
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .foregroundColor(.green)
                .frame(width: 70,height: 70)
                .cornerRadius(50)
                .padding(15)
            
            Text("\(title)")
                .multilineTextAlignment(.center)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.green)
                .tracking(1.4)
                .padding(.leading,15)
                .padding(.trailing,15)
            
            Text("\(text)")
                .multilineTextAlignment(.center)
                .padding(.leading,5)
                .padding(.trailing,15)
                .padding(.top,5)
                .padding(.bottom,45)
            
            ZStack {
                GeometryReader { geo in
                    ZStack {
                        WaveShape(waveHeight: 30, phase: Angle(degrees: (Double(geo.frame(in: .global).minY)) ))
                            .foregroundColor(.gray)
                            .opacity(0.5)
                        WaveShape(waveHeight: 20, phase: Angle(degrees: Double(geo.frame(in: .global).minY) * 0.7))
                            .foregroundColor(.green.opacity(0.4))
                    }
                }
                .frame(height: 75, alignment: .bottom)
                
                ZStack{
                    Text("Close")
                        .fontWeight(.bold)
                        .font(.system(size: 19))
                        .foregroundColor(.white)
                        .padding(.top,10)
                        .padding(.bottom,10)
                        .padding(.leading,15)
                        .padding(.trailing,15)
                        .onTapGesture {
                            withAnimation{
                                showingAlert = false
                            }
                        }
                }
                .frame(width: 150)
                .background(
                    .green
                )
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.white, lineWidth: 1)
                )
                .padding(.all)
            }
        }
        .background(.white)
        .cornerRadius(5)
        .frame(width: width, height: height,alignment: .center)
        .transition(.scale)
    }
}
