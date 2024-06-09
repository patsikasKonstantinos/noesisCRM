//
//  CalendarContentView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 17/6/23.
//

import SwiftUI

struct CalendarContentView: View {
    
    //MARK: Variables
    @ObservedObject private var viewModel: CalendarViewModel
    var geometry:GeometryProxy
    
    //MARK: Initialization
    init(viewModel: CalendarViewModel,geometry:GeometryProxy) {
        self.viewModel = viewModel
        self.geometry = geometry
    }
    
    //MARK: Body
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "chevron.left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .padding(.leading, 15)
                    .padding(.vertical, 5)
                    .onTapGesture {
                        viewModel.changeMonth(by: -1)
                    }

                Spacer()

                Text(viewModel.displayedMonthString)
                    .font(.title)
                    .padding(.vertical, 5)

                Spacer()

                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .padding(.trailing, 15)
                    .padding(.vertical, 5)
                    .onTapGesture {
                        viewModel.changeMonth(by: 1)
                    }
            }
            .frame(maxWidth: .infinity)
            .background(.white)
            .padding(.vertical, 10)

            LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 10) {
                ForEach(viewModel.weekdayNames, id: \.self) { weekday in
                    Text(weekday)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }

                ForEach(viewModel.datesInMonth, id: \.self) { date in
                    Text(viewModel.dateFormatter.string(from: date))
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .frame(width: geometry.size.width / 10)
                        .frame(minHeight: 50)
                        .padding(5)
                        .background(viewModel.backgroundColor(for: date).swiftUIColor)
                        .foregroundColor(viewModel.foregroundColor(for: date).swiftUIColor)
                        .onTapGesture {
                            viewModel.selectDate(date)
                        }
                        .onAppear{
                            viewModel.updateActiveDaysOff(date)
                        }
                        .sheet(isPresented: $viewModel.showDayOffSheet,onDismiss:{
                           //Update View
                            viewModel.updateActiveDaysOff(viewModel.selectedDate)
                       }) {
                           DaysOffView(viewModel: DaysOffViewModel(date: viewModel.selectedDate))
                       }
                }
            }
            .padding()
        }
        .background(.white)
    }
}
