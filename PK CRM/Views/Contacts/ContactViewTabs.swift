//
//  ContactViewTabs.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 12/6/23.
//

import SwiftUI

// MARK: - ContactViewTabs
struct ContactViewTabs: View {
    
    //MARK: Variables
    @Binding var openedTab: Int
    
    //MARK: Body
    var body: some View {
        HStack {
            Text("Details")
                .padding(10)
                .background(openedTab == 1 ? .green.opacity(0.8) : .white)
                .foregroundColor(openedTab == 1 ? .white : .black)
                .onTapGesture {
                    openedTab = 1
                }
            
            Text("Incomes")
                .padding(10)
                .background(openedTab == 2 ? .green.opacity(0.8) : .white)
                .foregroundColor(openedTab == 2 ? .white : .black)
                .onTapGesture {
                    openedTab = 2
                }
            
            Text("Expenses")
                .padding(10)
                .background(openedTab == 3 ? .green.opacity(0.8) : .white)
                .foregroundColor(openedTab == 3 ? .white : .black)
                .onTapGesture {
                    openedTab = 3
                }
            
            Text("Sum")
                .padding(10)
                .background(openedTab == 4 ? .green.opacity(0.8) : .white)
                .foregroundColor(openedTab == 4 ? .white : .black)
                .onTapGesture {
                    openedTab = 4
                }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedCornersShape(corners: [.bottomRight], radius: 15)
                .fill(Color.gray.opacity(0.1))
        )
        .padding(.horizontal, 15)
    }
}
