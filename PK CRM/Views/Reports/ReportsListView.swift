//
//  ReportsListView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 27/7/23.
//

import SwiftUI

struct ReportsListView: View {
    
    //MARK: Variables
    @ObservedObject var viewModel: ReportsViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @State var openEconomicsReport:Bool = false
    @State var openEvaluationReport:Bool = false
    @State var showLoaderEconomicsReport:Bool = false
    @State var showLoaderEvaluationReport:Bool = false

    //MARK: Initialization
    init(viewModel: ReportsViewModel) {
        self.viewModel = viewModel
    }
    
    //MARK: Body
    var body: some View {
        VStack{
            List {
                
                HStack{
                    Image(systemName: "dollarsign")
                        .mainMenuImagesStyle(background: AppColors.greenOpacity06.swiftUIColor)

                    Text(Variables.allReportsList[1])
                    
                    Spacer()
             
                    if showLoaderEconomicsReport {
                        ProgressView()
                            .scaleEffect(1)
                            .progressViewStyle(CircularProgressViewStyle(tint: Color(UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1))))
                            .background(.white)
                            .cornerRadius(50)
                    }
//                    else{
//                        Image(systemName: "chevron.right")
//                            .foregroundColor(Color(UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)))
//                            .imageScale(.small)
//
//                    }
 
                    
                 }
                 .contentShape(Rectangle())
                 .onTapGesture {
                    openEconomicsReport = true
                    showLoaderEconomicsReport = true
                 }
                
                HStack{
                    Image(systemName: "star.fill")
                        .mainMenuImagesStyle(background: AppColors.greenOpacity06.swiftUIColor)

                    Text(Variables.allReportsList[0])
                    
                    Spacer()
             
                    if showLoaderEvaluationReport {
                        ProgressView()
                            .scaleEffect(1)
                            .progressViewStyle(CircularProgressViewStyle(tint: Color(UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1))))
                            .background(.white)
                            .cornerRadius(50)
                    }
//                    else{
//                        Image(systemName: "chevron.right")
//                            .foregroundColor(Color(UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)))
//                            .imageScale(.small)
//                    }
 
                    
                 }
                 .contentShape(Rectangle())
                 .onTapGesture {
                     openEvaluationReport = true
                     showLoaderEvaluationReport = true
                 }
            }
            .scrollContentBackground(.hidden)
            .background(settingsViewModel.appAppearance.themeBackgroundColor)
        }
        .onAppear{
            showLoaderEconomicsReport = false
            showLoaderEvaluationReport = false

        }
        .navigationDestination(isPresented: $openEconomicsReport) {
            EconomicsReportView(viewModel: viewModel)
        }
        .navigationDestination(isPresented: $openEvaluationReport) {
            EmployeeEvaluationsReportView(viewModel: viewModel)
        }
        .navigationBarLeadingViewModifier(
            withTitle: "Reports", withColor: settingsViewModel.appAppearance
        )
        .navigationBarTitleDisplayMode(.inline)
    }
}

 
