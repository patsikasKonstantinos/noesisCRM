//
//  EmployeeEvaluationsReportFilters.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 28/7/23.
//

import SwiftUI
 

struct EconomicsReportViewFilters: View {
    
    //MARK: Variables
    @ObservedObject var viewModel:ReportsViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @State var initialized:Bool = false
    @State var economicsFilterYear:Int
    @State var economicsKindFilter:Int
    @State var economicsCustomersFilter:[Contacts] = []
    @State var fromNavigation:Bool = false
     
    //MARK: Initialization
    init(viewModel: ReportsViewModel) {
        self.viewModel = viewModel
        _economicsFilterYear = State(initialValue: viewModel.economicsFilterYear)
        _economicsKindFilter = State(initialValue: viewModel.economicsKindFilter)
    }
    
    //MARK: Body
    var body: some View {
        NavigationStack{
            VStack(spacing:0){
                HStack{
                    Text("Reset")
                        .foregroundColor(.blue)
                        .padding(.leading,20)
                        .onTapGesture {
                            let reset = viewModel.resetEconomicsFilters()
                            economicsFilterYear = reset.0
                            economicsKindFilter = reset.1
                            economicsCustomersFilter = reset.2 as? [Contacts] ?? []
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
                            viewModel.submitEconomicsFilter(economicsKindFilter,economicsFilterYear,economicsCustomersFilter)
                        }
                }
                .padding(.vertical,10)
                .background(settingsViewModel.appAppearance.themeBackgroundColor)
                .frame(maxWidth:.infinity,alignment: .top)

                List{
                    HStack{
                        Text("Year")
                        
                        Picker("", selection: $economicsFilterYear) {
                            ForEach(Variables.startYear...Variables.endYear, id: \.self) { year in
                                Text("\(viewModel.formatYearFilterToString(year))").tag(year)
                           }
                        }
                        .pickerStyle(.wheel)
                    }
                     
                    HStack {
                        Text("Kind")
                        
                        Picker("", selection: $economicsKindFilter) {
                            ForEach(Array(Variables.economicsKindFilter.sorted(by: { $0.key < $1.key })), id: \.key) { key, value in
                                // Use the key and value to create your view here
                                Text("\(value)").tag(key)
                                     .foregroundColor(.blue)
                            }
                       }
                    }
                    
                    HStack{
                        Text("Contacts:")
                        
                        NavigationLink{
                            SelectContactsView(
                                viewModel:viewModel.selectContactsViewModel,
                                fromNavigation: $fromNavigation
                            )
                            .navigationBarLeadingViewModifier(withTitle: "Contacts", withColor: settingsViewModel.appAppearance)
                            .navigationBarTitleDisplayMode(.inline)
                        
                        } label: {
                            VStack(alignment: .leading) {

                                if economicsCustomersFilter.count > 0 {
                                    ForEach(0..<economicsCustomersFilter.count,id:\.self) {
                                        i in
                                        if !economicsCustomersFilter[i].isInvalidated {
                                            Text("\(economicsCustomersFilter[i].firstName) \(economicsCustomersFilter[i].surnName)")
                                                .foregroundColor(.blue)
                                                .font(.system(size: 15))
                                                .padding(.leading, 5)
                                            
                                            if economicsCustomersFilter[i] != economicsCustomersFilter.last {
                                                Divider()
                                            }
                                        }
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .onAppear{
                economicsCustomersFilter = viewModel.selectContactsViewModel.selected
            }
        }
    }
}
     

 

 

