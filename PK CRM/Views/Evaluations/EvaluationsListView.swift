//
//  EvaluationsListView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 31/12/22.
//

import SwiftUI

struct EvaluationsListView: View {
    
    //MARK: Variables
    @ObservedObject private var viewModel: EvaluationsListViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    //MARK: Initialization
    init(viewModel: EvaluationsListViewModel) {
        self.viewModel = viewModel
    }
    
    //MARK: Body
    var body: some View {
        VStack {
            
            if viewModel.filteredEvaluations.count > 0 {
                List {
                    ForEach(Array(viewModel.filteredEvaluations.enumerated()), id: \.1.id) { index, evaluation in
                        
                        ZStack{
                            NavigationLink {
                                EvaluationView(viewModel: EvaluationViewModel(newEvaluations: false, evaluationsId: evaluation.id))
                            } label: {
                                Text("\(evaluation.title)")
                                    .foregroundColor(Color.black)
                            }
                        }
                    }
                    .onDelete(perform: viewModel.deleteEvaluation)
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
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
        .navigationBarLeadingViewModifier(
            withTitle: "Evaluations", withColor: settingsViewModel.appAppearance
        )
        .navigationBarItems(trailing:
            HStack {
                Spacer()
            
                NavigationLink{
                    EvaluationView(viewModel: EvaluationViewModel(newEvaluations: true, evaluationsId: viewModel.evaluationID))
                    
                } label: {
                    Text("Add")
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                }
            }
            .padding(.vertical, 10)
        )
        .background(settingsViewModel.appAppearance.themeBackgroundColor)
    }
}
