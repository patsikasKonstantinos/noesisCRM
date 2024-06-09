//
//  EconomicsContactSummation.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 15/4/23.
//

import Foundation
import SwiftUI
import RealmSwift
 
struct EconomicsContactSummation: View {
   
    //MARK: Variables
    @ObservedObject var viewModel: EconomicsContactSummationViewModel

    //MARK: Initialization
    init(viewModel: EconomicsContactSummationViewModel) {
        self.viewModel = viewModel
        viewModel.setup()
    }

    //MARK: Body
    var body: some View {
        VStack{
            HStack{
                Spacer()
                
                VStack {
                    HStack{
                        Text("Incomes")
                            .fontWeight(.light)
                            .foregroundColor(Color.black.opacity(0.7))

                        Spacer()
                    }

                    Text("\(viewModel.sums[0] ?? "0.0")\(Variables.currency)")
                        .fontWeight(.bold)
                        .padding(.top,0.5)
                }
                .frame(maxWidth: .infinity,alignment: .top)
                .padding()
                .background(Color.white)
                .cornerRadius(10)

                VStack {
                    HStack{
                        Text("Expenses")
                            .fontWeight(.light)
                            .foregroundColor(Color.black.opacity(0.7))

                        Spacer()
                    }

                    Text("\(viewModel.sums[1] ?? "0.0")\(Variables.currency)")
                        .fontWeight(.bold)
                        .padding(.top,0.5)
                }
                .frame(maxWidth:.infinity,alignment: .top)
                .padding()
                .background(Color.white)
                .cornerRadius(10)

                Spacer()
            }
            
            HStack{
                Spacer()
                
                VStack {
                    HStack{
                        Text("Net Income")
                            .fontWeight(.light)
                            .foregroundColor(Color.black.opacity(0.7))
                        
                        Spacer()
                    }
                         
                    Text("\(viewModel.sums[2] ?? "0.0")\(Variables.currency)")
                        .fontWeight(.bold)
                        .font(.system(size: 22))
                        .foregroundColor(viewModel.sums[3] == "positive" ? .green : viewModel.sums[3] == "zero" ? .black : .red)
                   
                }
                .frame(maxHeight:50,alignment: .top)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .top)
    }
}
