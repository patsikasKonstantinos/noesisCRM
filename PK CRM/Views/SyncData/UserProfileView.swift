//
//  UserProfileView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 28/6/23.
//

import SwiftUI

struct UserProfileView: View {
    
    //MARK: Variables
    @ObservedObject var viewModel: SyncDataViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    //MARK: Initialization
    init(viewModel: SyncDataViewModel) {
        self.viewModel = viewModel
    }

    //MARK: Body
    var body: some View {
        ZStack{
            VStack{
                List{
                    Section {
                        NavigationLink{
                            UserProfileDataView(viewModel: viewModel)
                                .navigationTitle("Appearance")
                                .navigationBarLeadingViewModifier(
                                    withTitle: "Appearance", withColor: settingsViewModel.appAppearance
                                )
                                .navigationBarTitleDisplayMode(.inline)
                        } label: {
                            HStack{
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50,height: 35)
                                
                                VStack(alignment: .leading){
                                    Text("\(viewModel.user.name) \(viewModel.user.surname)")
                                        .font(.title3)
                                    
                                    Text("\(viewModel.user.email)")
                                        .font(.subheadline)
                                 }
                            }
                        }
                    }
                    
                    Section {
                        HStack{
                            Image(systemName: "icloud.and.arrow.down.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.green)
                                .frame(width: 25,height: 30)
                                .padding(.leading,12)
                                .padding(.trailing,12)

                            Text("Import")
                            
                            Rectangle()
                                .fill(Color.clear)
                                .contentShape(Rectangle())
                                .alert(isPresented: $viewModel.downloaddDatabaseAlert) {
                                    Alert(
                                       title: Text("Are you sure you want to import the database?"),
                                       message: Text("Αll existing data will be merged with your new account data!"),
                                       primaryButton: .default(Text("Yes"), action: {
                                           viewModel.downloadAllDatabases()
                                       }),
                                       secondaryButton: .cancel(Text("Cancel"),action: {
                                       })
                                   )
                                }
                        }
                        .onTapGesture {
                            viewModel.downloaddDatabaseAlert = true
                        }

                        HStack{
                            Image(systemName: "icloud.and.arrow.up.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .frame(width: 25,height: 30)
                                .padding(.leading,12)
                                .padding(.trailing,12)

                            Text("Export")
                            
                            Rectangle()
                                .fill(Color.clear)
                                .contentShape(Rectangle())
                                .alert(isPresented: $viewModel.uploadDatabaseAlert) {
                                    Alert(
                                       title: Text("Are you sure you want to upload the database?"),
                                       message: Text("All of your data will be upload on your account!"),
                                       primaryButton: .default(Text("Yes"), action: {
                                           viewModel.uploadAllDatabases()
                                       }),
                                       secondaryButton: .cancel(Text("Cancel"),action: {
                                       })
                                   )
                                }
                        }
                        .onTapGesture {
                            viewModel.uploadDatabaseAlert = true
                        }
                    }
                     
                    Section{
                        ZStack{
                            Text("Logout")
                                .foregroundColor(.red)
                                .frame(maxWidth:.infinity,alignment: .center)
                            
                            Rectangle()
                                .fill(Color.clear)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    viewModel.logout()
                                }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationBarBackButtonHidden(viewModel.showDatabaseProgress ? true : false)
            .background(settingsViewModel.appAppearance.themeBackgroundColor)
            
            //Progressive
            if viewModel.showDatabaseProgress {
                
                ZStack {
                    ZStack{
                        VStack{
                            if !viewModel.syncResponseMessage.isEmpty {
                                
                                viewModel.syncResponseSuccess ?
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .foregroundColor(.green)
                                    .frame(width: 60,height: 60)
                                    .background(.white)
                                    .cornerRadius(50) :
                                Image(systemName: "clear.fill")
                                    .resizable()
                                    .foregroundColor(.red)
                                    .frame(width: 60,height: 60)
                                    .background(.white)
                                    .cornerRadius(50)
                                
                            }else{
                                
                                ProgressView()
                                    .frame(width: 60,height: 60)
                                    .scaleEffect(1.5)
                                    .progressViewStyle(CircularProgressViewStyle(tint: Color(UIColor(red: 0.05, green: 0.64, blue: 0.82, alpha: 1))))
                                    .background(.white)
                                    .cornerRadius(50)
                            }
                        }
                        .zIndex(2)
                        .frame(width: 60,height: 60,alignment: .center )
                        .background(.white)
                        .cornerRadius(50)
                        .offset(y: -75)
                            
                        VStack{
                            Text(!viewModel.syncResponseMessage.isEmpty ?
                                 viewModel.syncResponseMessage : viewModel.syncProcessingText)
                                .frame(maxWidth:.infinity,maxHeight:.infinity,alignment: .center)
                                .multilineTextAlignment(.center)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.black)
                                
                        }
                        .zIndex(1)
                        .background(.white)
                        .cornerRadius(10)
                        .padding(.leading,10)
                        .padding(.trailing,10)
                    }
                    .frame(maxWidth: 300, maxHeight: 150,alignment: .center)
                    .padding(.vertical, 25)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    Color.primary.opacity(0.35)
                )
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

 
