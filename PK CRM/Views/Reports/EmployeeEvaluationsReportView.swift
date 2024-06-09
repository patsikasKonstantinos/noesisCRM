//
//  EmployeeEvaluationsReport.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 27/7/23.
//

import SwiftUI

struct EmployeeEvaluationsReportView: View {
    
    //MARK: Variables
    @ObservedObject var viewModel: ReportsViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    //MARK: Initialization
    init(viewModel: ReportsViewModel) {
        self.viewModel = viewModel
    }
    
    //MARK: Body
    var body: some View {
        VStack{
             
            if viewModel.evaluations.count > 0 {
                List {
                    ForEach(Array(viewModel.evaluations.enumerated()), id: \.element.id) { (index, evaluation) in
                        HStack{
                            Text("\(index+1).")
                                .foregroundColor(Color.black)
                                .font(.system(size: 15))
                                .fontWeight(.bold)
                            
                            Text("\(evaluation.title)")
                                .foregroundColor(Color.black)
                            
                            Spacer()
                            
                            Text(String(format: "%.2f", viewModel.sortingΕvaluationsArray[evaluation.id] ?? 0.00))
                                .foregroundColor(Color.blue)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scrollContentBackground(.hidden)
            } else {
                HStack {
                    Spacer()
                    Text("Evaluations Not Found")
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(maxWidth:.infinity,alignment: .center)
        .navigationBarItems(
            trailing:
                Text("Filters")
                .foregroundColor(.blue)
                .fontWeight(.bold)
                .padding(.vertical, 10)
                .onTapGesture {
                    viewModel.showFilters.toggle()
                }
                .sheet(isPresented: $viewModel.showFilters,onDismiss:{}) {
                   EmployeeEvaluationsReportViewFilters(viewModel: viewModel)
               }
        )
        .navigationBarLeadingViewModifier(
            withTitle: "Employee Evaluations", withColor: settingsViewModel.appAppearance
        )
        .navigationBarTitleDisplayMode(.inline)
        .background(settingsViewModel.appAppearance.themeBackgroundColor)
    }
}
