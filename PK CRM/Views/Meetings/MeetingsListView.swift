//
//  MeetingsListView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 31/12/22.
//

import SwiftUI
 
struct MeetingsListView: View {
    
    //MARK: Variables
    @ObservedObject private var viewModel: MeetingsListViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    //MARK: Initialization
    init(viewModel: MeetingsListViewModel) {
        self.viewModel = viewModel
    }
    
    //MARK: Body
    var body: some View {
        VStack {
            if viewModel.filteredMeetings.count > 0 {
                List {
                  
                    ForEach(Array(viewModel.filteredMeetings.enumerated()), id: \.1.id) { index, meeting in

                        ZStack{
                            NavigationLink{
                                MeetingView(
                                    viewModel: MeetingViewModel(
                                        newMeeting: false, meetingId: meeting.id
                                    )
                                )
                            } label: {
                                HStack{
                                    CalendarDayView(date: meeting.date)
                                    
                                    if !meeting.customers.isEmpty {
                                        VStack{
                                            Text("\(meeting.title), \(meeting.customers[0].firstName) \(meeting.customers[0].surnName)")
                                                .infinityLeading()
                                                .foregroundColor(Color.black)
                                            
                                            Text("\(meeting.date.hour)")
                                                .infinityLeading()
                                                .foregroundColor(.gray)
                                                .font(.system(size:15))
                                        }
                                        .frame(alignment:.leading)
                                    } else {
                                        VStack{
                                            Text("\(meeting.title)")
                                                .infinityLeading()
                                                .foregroundColor(Color.black)
                                                
                                            Text("\(meeting.date.hour)")
                                                .infinityLeading()
                                                .foregroundColor(.gray)
                                                .font(.system(size:15))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .onDelete(perform: viewModel.deleteMeeting)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scrollContentBackground(.hidden)
            }
            else {
                HStack {
                    Spacer()
                    
                    Text("Meetings Not Found")
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
        .navigationBarLeadingViewModifier(
            withTitle: "Meetings", withColor: settingsViewModel.appAppearance
        )
        .navigationBarItems(
            trailing:
                HStack {
                    Text("Filters")
                        .foregroundColor(.blue)
                        .padding(.vertical, 10)
                        .onTapGesture {
                            viewModel.showFilters.toggle()
                        }
                        .sheet(isPresented: $viewModel.showFilters,onDismiss:{}) {
                          MeetingsListViewFilters(viewModel: viewModel)
                       }
                    
                        NavigationLink {
                            MeetingView(viewModel: MeetingViewModel(newMeeting: true, meetingId: viewModel.meetingID))
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
