//
//  MeetingsListViewFilters.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 28/7/23.
//

import SwiftUI
 

struct MeetingsListViewFilters: View {
    
    //MARK: Variables
    @ObservedObject var viewModel:MeetingsListViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @State var filterStartDate:Date
    @State var filterFinishDate:Date
    @State var sortMeetings:Int
 
    //MARK: Initialization
    init(viewModel: MeetingsListViewModel) {
        self.viewModel = viewModel
        _filterStartDate = State(initialValue: viewModel.filterStartDate)
        _filterFinishDate = State(initialValue: viewModel.filterFinishDate)
        _sortMeetings = State(initialValue: viewModel.sortMeetings)
    }
    
    //MARK: Body
    var body: some View {
        VStack(spacing:0){
            HStack{
                Text("Reset")
                    .foregroundColor(.blue)
                    .padding(.leading,20)
                    .onTapGesture {
                        let reset = viewModel.resetMeetingsFilters()
                        filterStartDate = reset.0
                        filterFinishDate = reset.1
                        sortMeetings = reset.2
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
                        viewModel.submitMeetingsFilter(filterStartDate,filterFinishDate,sortMeetings)
                    } 
            }
            .padding(.vertical,10)
            .background(settingsViewModel.appAppearance.themeBackgroundColor)
            .frame(maxWidth:.infinity)

            List{
                Section{
                    HStack{
                        Text("Start Date")
                        
                        DatePicker("", selection: $filterStartDate, displayedComponents: [.date, .hourAndMinute])
                    }
                    .padding(.vertical, 5)
                    .frame(maxWidth:.infinity,alignment: .leading)
                     
                    HStack{
                        Text("Finish Date")
                        
                        DatePicker("", selection: $filterFinishDate, displayedComponents: [.date, .hourAndMinute])
                    }
                    .frame(maxWidth:.infinity,alignment: .leading)
                    .padding(.vertical, 5)
                }
                
                Section{
                    HStack {
                        Text("Sort")
                            .foregroundColor(.blue)
                        
                        Picker("", selection: $sortMeetings) {
                            ForEach(Array(Variables.sortMeetings.sorted(by: { $0.key < $1.key })), id: \.key) { key, value in
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

