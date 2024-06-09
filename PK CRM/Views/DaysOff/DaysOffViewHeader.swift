//
//  DaysOffViewHeader.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 17/6/23.
//

import SwiftUI

extension DaysOffView{

    func DaysOffViewHeader()  -> some View {
        
        HStack{
            HStack{
                Text("Back")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        dismiss()
                    }
                
                Spacer()
                
                Text("Day Off")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("Save")
                    .foregroundColor(!viewModel.showingAlert ? .blue : .blue.opacity(0.3))
                    .fontWeight(.bold)
                    .onTapGesture {
                        viewModel.saveDaysOff()
                    }
                    .onReceive(viewModel.dismissRequest) { _ in
                        dismiss() //
                    }
            }
            .padding(.horizontal,15)
        }
        .frame(height: 60)
        .background(Color.white)
    }
}
