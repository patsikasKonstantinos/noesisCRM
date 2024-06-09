//
//  UserRegisterView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 22/6/23.
//

import SwiftUI

struct UserRegisterView: View {
    
    //MARK: Variables
    @ObservedObject var viewModel: SyncDataViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var repeatPassword: String = ""
    @State private var showingAlert:Bool = false
    @State private var isPasswordVisible: Bool = false
    @State private var isRepeatPasswordVisible: Bool = false

    //MARK: Initialization
    init(viewModel: SyncDataViewModel ) {
        self.viewModel = viewModel
    }

    //MARK: Body
    var body: some View {
       VStack {
           GeometryReader { geometry in
               ScrollView(showsIndicators: false){
                   HStack{
                       Spacer()
                       
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
                               
                           }else{
                            
                               VStack{
                                   List{
                                       Section{
                                          
                                           TextField("E-mail", text: $email)
                                               .frame(height: 40)
                                               .padding(.leading,10)
                                               .padding(.trailing,10)
                                               .background(Color(.white))
                                               .cornerRadius(8)

                                           TextField("Name", text: $name)
                                               .frame(height: 40)
                                               .padding(.leading,10)
                                               .padding(.trailing,10)
                                               .background(Color(.white))
                                               .cornerRadius(8)
                                           
                                           TextField("Surname", text: $surname)
                                               .frame(height: 40)
                                               .padding(.leading,10)
                                               .padding(.trailing,10)
                                               .background(Color(.white))
                                               .cornerRadius(8)
                                           
                                           HStack{
                                               
                                               if isPasswordVisible {
                                                  TextField("Password", text: $password)
                                                      .frame(height: 40)
                                                      .padding(.leading,10)
                                                      .padding(.trailing,10)
                                                      .background(Color(.white))
                                                      .cornerRadius(8)
                                               }else{
                                                   SecureField("Password", text: $password)
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
                                               
                                               if isRepeatPasswordVisible {
                                                  TextField("Repeat Password", text: $repeatPassword)
                                                      .frame(height: 40)
                                                      .padding(.leading,10)
                                                      .padding(.trailing,10)
                                                      .background(Color(.white))
                                                      .cornerRadius(8)
                                               }else{
                                                   SecureField("Repeat Password", text: $repeatPassword)
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
                                       }
                                       
                                       Section{
                                           ZStack{
                                               Text("Register")
                                                   .foregroundColor(.blue)
                                                   .frame(maxWidth:.infinity,alignment: .center)
                                               
                                               Rectangle()
                                                   .fill(Color.clear)
                                                   .contentShape(Rectangle())
                                                   .onTapGesture {
                                                       if !viewModel.loader{
                                                           viewModel.register(email,password,repeatPassword,name,surname)
                                                       }
                                                   }
                                           }
                                       }
                                   }
                                   .scrollContentBackground(.hidden)
                               }
                               .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                           }
                       }
                       .frame(height: geometry.size.height)
                       
                       Spacer()
                   }
               }
           }
       }
       .onAppear{
           viewModel.loginAlert = false
       }
       .background(settingsViewModel.appAppearance.themeBackgroundColor)
       .frame(maxHeight: .infinity, alignment: .bottom)
       .onChange(of: viewModel.loginAlert) { _ in
           withAnimation{
               showingAlert = viewModel.loginAlert
           }
       }
   }
}


 
