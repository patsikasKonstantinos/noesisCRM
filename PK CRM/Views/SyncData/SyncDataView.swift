//
//  SyncDataView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 27/6/23.
//

import SwiftUI

struct SyncDataView: View {
    
    //MARK: Variables
    @ObservedObject var viewModel: SyncDataViewModel
    @State var checkUserActive: Bool 

    //MARK: Initialization
    init(viewModel: SyncDataViewModel) {
        self.viewModel = viewModel
        self.checkUserActive = viewModel.checkUserActive
    }
    
    //MARK: Body
    var body: some View {
        VStack{
            if viewModel.navigationToSyncDataView{
                ProgressView()
                    .scaleEffect(x: 2, y: 2, anchor: .center)
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .frame(alignment: .center)
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.viewModel.navigationToSyncDataView = false
                        }
                    }

            }else{
                
                if checkUserActive {
                    UserProfileView(viewModel:viewModel)
                        .transition(.move(edge: .trailing))
                    
                 }else{
                     Picker("", selection:   $viewModel.loginMode) {
                        Text("Login").tag(1)
                        Text("Register").tag(2)
                     }
                     .pickerStyle(.segmented)
                     .padding(.horizontal)
        
                     if viewModel.loginMode == 1 {
                         UserLoginView(viewModel:viewModel)
                     }else{
                         UserRegisterView(viewModel:viewModel)
                     }
                 }
            }
        }
        //remove the default Navigation Bar space:
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing: SyncDataLoader()
        )
        .frame(maxHeight:.infinity,alignment: .top)
        .onChange(of: viewModel.checkUserActive) { newValue in
            withAnimation {
                checkUserActive = newValue
            }
        }
        .onAppear{
            checkUserActive = viewModel.checkUserActive
        }
    }
}

 
