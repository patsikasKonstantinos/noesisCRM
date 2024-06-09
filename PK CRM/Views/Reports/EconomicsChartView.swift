//
//  EconomicsChartView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 29/7/23.
//

import SwiftUI
import Charts
 
struct EconomicsChartView: View {
     
    //MARK: Variables
    @ObservedObject var viewModel: ReportsViewModel
    
    //MARK: Initialization
    init(viewModel: ReportsViewModel) {
        self.viewModel = viewModel
    }
    
    //MARK: Body
    var body: some View {
        VStack{
            Text("Year: \(viewModel.formatYearFilterToString(viewModel.economicsFilterYear))")
                .font(.system(size: 14))
                .fontWeight(.bold)
                .padding(.leading,15)
                .frame(maxWidth:.infinity,alignment:viewModel.economicsCustomersFilter.count > 0 ? .leading : .center)
            
            if viewModel.economicsCustomersFilter.count > 0 {
                HStack{
                    Text("Contacts:")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .padding(.bottom,10)

                    ScrollView(.horizontal,showsIndicators: false) {
                        HStack{
                            ForEach(0..<viewModel.economicsCustomersFilter.count,id:\.self) { i in
                                if !viewModel.economicsCustomersFilter[i].isInvalidated {
                                    Text("\(viewModel.economicsCustomersFilter[i].firstName) \(viewModel.economicsCustomersFilter[i].surnName)")
                                        .foregroundColor(.blue)
         
                                    if viewModel.economicsCustomersFilter[i] != viewModel.economicsCustomersFilter.last {
                                        Text(",")
                                    }
                                }
                            }
                        }
                        .padding(.bottom,10)
                    }
                }
                .padding(.leading,15)
                .frame(maxWidth:.infinity,alignment: .leading)
            }

            HStack{
                
                if viewModel.economicsKindFilter == 0 ||
                    viewModel.economicsKindFilter == 1 {
                    Rectangle()
                        .frame(width: 20,height: 10)
                        .foregroundColor(.green)
                    
                    Text("Incomes")
                    
                }
                
                if viewModel.economicsKindFilter == 0 ||
                    viewModel.economicsKindFilter == 2 {
                    Rectangle()
                        .frame(width: 20,height: 10)
                        .foregroundColor(.red)
                    
                    Text("Expenses")
                }
            }
            
            Chart (content: {
                
                //Incomes
                if viewModel.economicsKindFilter == 0 ||
                    viewModel.economicsKindFilter == 1 {
                    ForEach(viewModel.payments[.incomes]!,id:\.self) { income in
                        LineMark(
                            x: .value("Month", income.month),
                            y: .value("Total", income.amount),
                            series: .value("incomes", "incomes")
                        )
                        .foregroundStyle(.green)
                    }
                }
                
                //Expenses
                if viewModel.economicsKindFilter == 0 ||
                    viewModel.economicsKindFilter == 2 {
                    ForEach(viewModel.payments[.expenses]!,id:\.self) { expense in
                        LineMark(
                            x: .value("Month", expense.month),
                            y: .value("Total", expense.amount),
                            series: .value("expenses", "expenses")
                        )
                        .foregroundStyle(.red)
                    }
                }
            })
        }
    }
}
