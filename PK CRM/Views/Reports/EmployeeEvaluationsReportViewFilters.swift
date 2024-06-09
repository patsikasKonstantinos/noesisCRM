//
//  EmployeeEvaluationsReportFilters.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 28/7/23.
//

import SwiftUI
 

struct EmployeeEvaluationsReportViewFilters: View {
    
    //MARK: Variables
    @ObservedObject var viewModel:ReportsViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @State var filterStartDate:Date
    @State var filterFinishDate:Date
    @State var sortEvaluations:Int
    @State var filterSumEvaluation:Int
 
    //MARK: Initialization
    init(viewModel: ReportsViewModel) {
        self.viewModel = viewModel
        _filterStartDate = State(initialValue: viewModel.filterStartDate)
        _filterFinishDate = State(initialValue: viewModel.filterFinishDate)
        _sortEvaluations = State(initialValue: viewModel.sortEvaluations)
        _filterSumEvaluation = State(initialValue: viewModel.filterSumEvaluation)
    }
    
    //MARK: Body
    var body: some View {
        VStack(spacing:0){
            HStack{
                Text("Reset")
                    .foregroundColor(.blue)
                    .padding(.leading,20)
                    .onTapGesture {
                        let reset = viewModel.resetEvaluationFilters()
                        filterStartDate = reset.0
                        filterFinishDate = reset.1
                        sortEvaluations = reset.2
                        filterSumEvaluation = reset.3
                }
                
                Spacer()
                
                Text("Filters")
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("Done")
                    .foregroundColor(.blue)
                    .fontWeight(.bold)
                    .padding(.trailing,20)
                    .onTapGesture {
                        viewModel.submitEvaluationFilter(filterStartDate,filterFinishDate,sortEvaluations,filterSumEvaluation)
                    }
            }
            .padding(.vertical,10)
            .background(settingsViewModel.appAppearance.themeBackgroundColor)
            .frame(maxWidth:.infinity)
             
            List{
                Section{
                    HStack{
                        Text("Start Date")
                        
                        DatePicker("", selection: $filterStartDate, displayedComponents: [.date])
                    }
                    .padding(.vertical, 5)
                    .frame(maxWidth:.infinity,alignment: .leading)
                     
                    HStack{
                            Text("Finish Date")
                            DatePicker("", selection: $filterFinishDate, displayedComponents: [.date])
                    }
                    .frame(maxWidth:.infinity,alignment: .leading)
                    .padding(.vertical, 5)
                }
                
                Section{
                    HStack(spacing:0){
                        VStack{
                            Text("Evaluation")
                            
                            Text("Equal to")
                                .fontWeight(.light)
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            
                            Text("or")
                                .fontWeight(.light)
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            
                            Text("Greater than")
                                .fontWeight(.light)
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                        }
                            
                        Picker("", selection: $filterSumEvaluation) {
                            ForEach(Variables.filterEvaluationsValues, id: \.self) { value in
                               Text("\(value)").tag(value)
                                    .foregroundColor(.blue)
                            }
                       }
                       .pickerStyle(.wheel)
                    }
                    .frame(maxWidth:.infinity,alignment: .leading)
                }
                 
                Section{
                    HStack {
                        Text("Sort")
                            .foregroundColor(.blue)
                        
                        Picker("", selection: $sortEvaluations) {
                            ForEach(Array(Variables.sortEvaluations.sorted(by: { $0.key < $1.key })), id: \.key) { key, value in
                                // Use the key and value to create your view here
                                Text("\(value)").tag(key)
                                     .foregroundColor(.blue)
                            }
                       }
                    }
                }
            }
        }
    }
}
     

 

 

