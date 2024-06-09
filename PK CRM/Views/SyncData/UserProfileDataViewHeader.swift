//
//  UserProfileDataViewHeader.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 16/6/23.
//

import SwiftUI

extension UserProfileDataView {
    
    func UserProfileDataViewHeader() -> some View {
        
        HStack{
            if viewModel.loader {
                ProgressView()
            }else{
                Text("Save")
                    .foregroundColor(!viewModel.loginAlert && !viewModel.freezeScreen ? .blue : .blue.opacity(0.3))
                    .fontWeight(.bold)
                    .onTapGesture {
                        if !viewModel.loader && !viewModel.loginAlert && !viewModel.freezeScreen{
                             viewModel.refreshUserData(viewModel.user.email, password, newPassword, repeatPassword, viewModel.user.name, viewModel.user.surname)
                        }
                    }
            }
        }
        .onReceive(viewModel.dismissRequest) { _ in
            dismiss() //
        }
    }
}
