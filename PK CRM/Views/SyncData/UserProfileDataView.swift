//
//  UserProfileDataView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 22/6/23.
//

import SwiftUI

struct UserProfileDataView: View {
    
    //MARK: Variables
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SyncDataViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @State private var isPasswordVisible: Bool = false
    @State private var isRepeatPasswordVisible: Bool = false
    @State private var isNewPasswordVisible: Bool = false
    @State var name: String = ""
    @State var surname: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var newPassword: String = ""
    @State var repeatPassword: String = ""
    @State var showingAlert:Bool = false
    

    //MARK: Initialization
    init(viewModel: SyncDataViewModel ) {
        self.viewModel = viewModel
    }
    
    //MARK: Body
    var body: some View {
       VStack {
           GeometryReader { geometry in
               ScrollView(showsIndicators: false){
                   VStack{
                       
                       if showingAlert {
                           // ALERT VIEW
                           VStack{
                               Spacer()
                               
                               WarningAlertView(
                                showingAlert: $viewModel.loginAlert,
                                text: $viewModel.alertText,
                                title: viewModel.alertTitle,
                                width: 300,
                                height: 300,
                                scrollable: false
                               )
                               .interactiveDismissDisabled()
                               
                               Spacer()
                           }
                           .frame(maxWidth: .infinity)
                           .transition(.scale)
                       }
                       
                       if !viewModel.freezeScreen {
                           if !showingAlert {
                            
                               VStack{
                                   List{

                                       Text("\(viewModel.user.email)")
                                           .padding(10)
                                           .background(Color(.white))
                                           .cornerRadius(8)

                                       TextField("Name", text: $viewModel.user.name)
                                           .padding(10)
                                           .background(Color(.white))
                                           .cornerRadius(8)
                                       
                                       TextField("Surname", text: $viewModel.user.surname)
                                           .padding(10)
                                           .background(Color(.white))
                                           .cornerRadius(8)
                                                                          
                                       HStack{
                                           
                                           if isPasswordVisible {
                                              TextField("Current Password", text: $password)
                                                  .frame(height: 40)
                                                  .padding(.leading,10)
                                                  .padding(.trailing,10)
                                                  .background(Color(.white))
                                                  .cornerRadius(8)
                                           }else{
                                               SecureField("Current Password", text: $password)
                                                   .frame(height: 40)
                                                   .padding(.leading,10)
                                                   .padding(.trailing,10)
                                                   .background(Color(.white))
                                                   .cornerRadius(8)
                                           }
                                                        
                                           if password.count > 0 {
                                               Image(systemName: !isPasswordVisible ? "eye.slash" : "eye")
                                                   .resizable()
                                                   .scaledToFit()
                                                   .frame(width: 25,height: 25)
                                                   .foregroundColor(.gray)
                                                   .onTapGesture {
                                                       isPasswordVisible.toggle()
                                                   }
                                           }
                                       }
                                       
                                       HStack{
                                           
                                           if isNewPasswordVisible {
                                              TextField("New Password", text: $newPassword)
                                                  .frame(height: 40)
                                                  .padding(.leading,10)
                                                  .padding(.trailing,10)
                                                  .background(Color(.white))
                                                  .cornerRadius(8)
                                           }else{
                                               SecureField("New Password", text: $newPassword)
                                                   .frame(height: 40)
                                                   .padding(.leading,10)
                                                   .padding(.trailing,10)
                                                   .background(Color(.white))
                                                   .cornerRadius(8)
                                           }
                                                        
                                           if newPassword.count > 0 {
                                               Image(systemName: !isNewPasswordVisible ? "eye.slash" : "eye")
                                                   .resizable()
                                                   .scaledToFit()
                                                   .frame(width: 25,height: 25)
                                                   .foregroundColor(.gray)
                                                   .onTapGesture {
                                                       isNewPasswordVisible.toggle()
                                                   }
                                           }
                                       }
                                       
                                       HStack{
                                           
                                           if isRepeatPasswordVisible {
                                              TextField("Repeat new password", text: $repeatPassword)
                                                  .frame(height: 40)
                                                  .padding(.leading,10)
                                                  .padding(.trailing,10)
                                                  .background(Color(.white))
                                                  .cornerRadius(8)
                                           }else{
                                               SecureField("Repeat new password", text: $repeatPassword)
                                                   .frame(height: 40)
                                                   .padding(.leading,10)
                                                   .padding(.trailing,10)
                                                   .background(Color(.white))
                                                   .cornerRadius(8)
                                           }
                                                        
                                           if repeatPassword.count > 0 {
                                               Image(systemName: !isRepeatPasswordVisible ? "eye.slash" : "eye")
                                                   .resizable()
                                                   .scaledToFit()
                                                   .frame(width: 25,height: 25)
                                                   .foregroundColor(.gray)
                                                   .onTapGesture {
                                                       isRepeatPasswordVisible.toggle()
                                                   }
                                                   
                                           }
                                       }
                                       
                                       Section{
                                           ZStack{
                                               Text("Delete Account")
                                                   .foregroundColor(.red)
                                                   .frame(maxWidth:.infinity,alignment: .center)
                                               
                                               Rectangle()
                                                   .fill(Color.clear)
                                                   .contentShape(Rectangle())
                                                   .onTapGesture {
                                                       viewModel.deleteAccountAlert = true
                                                   }
                                           }
                                           .alert(isPresented: $viewModel.deleteAccountAlert){
                                                   Alert(
                                                      title: Text("Are you sure you want to delete your account?"),
                                                      message: Text("All of your data and information will be deleted"),
                                                      primaryButton: .default(Text("Yes"), action: {
                                                          viewModel.deleteAccount()
                                                      }),
                                                      secondaryButton: .cancel(Text("Cancel"),action: {
                                                      })
                                                  )
                                            }
                                       }
                                   }
                                   .scrollContentBackground(.hidden)
                               }
                           }
                           
                       }else{
                           
                           if(!showingAlert){
                               ProgressView()
                                   .scaleEffect(x: 2, y: 2, anchor: .center)
                                   .frame(maxWidth: .infinity)
                                   .frame(alignment: .center)
                           }
                       }
                   }
                   .frame(height: geometry.size.height)
               }
           }
       }
       .onDisappear{
           viewModel.loginAlert = false
       }
       .onAppear{
           viewModel.profileOnAppearView()
           
       }
       .navigationBarTitleDisplayMode(.inline)
       .navigationBarItems(
           trailing: UserProfileDataViewHeader().padding(.vertical, 10)
       )
       .background(settingsViewModel.appAppearance.themeBackgroundColor)
       .frame(maxHeight: .infinity, alignment: .bottom)
       .onChange(of: viewModel.loginAlert) { _ in
           withAnimation{
               if !viewModel.loginAlert && viewModel.freezeScreen{
                   dismiss()
               }else{
                   showingAlert = viewModel.loginAlert
               }
           }
       }
   }
}


 
