//
//  CallsListView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 31/12/22.
//

import SwiftUI

struct CallsListView: View {
    
    //MARK: Variables
    @ObservedObject private var viewModel: CallsListViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    //MARK: Initialization
    init(viewModel: CallsListViewModel) {
        self.viewModel = viewModel
    }
    
    //MARK: Body
    var body: some View {
        VStack {

            if viewModel.filteredCalls.count > 0 {
                List {
                    ForEach(Array(viewModel.filteredCalls.enumerated()), id: \.1.id) { index, call in

                        ZStack{
                            NavigationLink{
                                CallView(
                                    viewModel: CallViewModel(newCall: false, callId: call.id)
                                )
                            } label: {
                                HStack{
                                    CalendarDayView(date: call.date)
                                    
                                    if !call.customers.isEmpty {
                                        VStack{
                                            Text("\(call.customers[0].firstName) \(call.customers[0].surnName)")
                                                .infinityLeading()
                                                .foregroundColor(Color.black)
                                            Text("\(call.date.hour)")
                                                .infinityLeading()
                                                .foregroundColor(.gray)
                                                .font(.system(size:15))
                                        }
                                    }
                                    else {
                                        Text("\(call.date.hour)")
                                            .infinityLeading()
                                            .foregroundColor(.gray)
                                            .font(.system(size:15))
                                    }
                                }
                            }
                        }
                    }
                    .onDelete(perform: viewModel.deleteCall)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onChange(of: viewModel.searchText) { searchText in
                    // Search Calls With Specific Criteria
                }
                .scrollContentBackground(.hidden)
            }
            else {
                HStack {
                    Spacer()
                    
                    Text("Calls Not Found")
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
        .navigationBarLeadingViewModifier(
            withTitle: "Calls", withColor: settingsViewModel.appAppearance
        )
        .navigationBarItems(trailing:
            HStack {
            
                Text("Filters")
                    .foregroundColor(.blue)
                    .padding(.vertical, 10)
                    .onTapGesture {
                        viewModel.showFilters.toggle()
                    }
                    .sheet(isPresented: $viewModel.showFilters,onDismiss:{}){
                      CallsListViewFilters(viewModel: viewModel)
                    }
            
                NavigationLink{
                    CallView(
                        viewModel: CallViewModel(newCall: true, callId: viewModel.callID)
                    )}
                    label: {
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
 
