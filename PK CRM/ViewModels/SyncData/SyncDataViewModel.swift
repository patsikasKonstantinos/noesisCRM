//
//  SyncDataViewModel.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 27/6/23.
//

import Foundation
import Combine

class SyncDataViewModel: ObservableObject {
    
    //MARK: Published Properties
    @Published var checkUserActive:Bool
    @Published var alertTitle = "Oops,"
    @Published var alertText = "Incorrect E-mail or Password"
    @Published var loginAlert: Bool = false
    @Published var deleteAccountAlert: Bool = false
    @Published var loader: Bool = false
    @Published var freezeScreen: Bool = false
    @Published var userEmail:String = ""
    @Published var loginMode:Int = 1
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var user: Users
    @Published var navigationToSyncDataView:Bool = false
    @Published var uploadDatabaseAlert:Bool = false
    @Published var downloaddDatabaseAlert:Bool = false
    @Published var showDatabaseProgress:Bool = false
    @Published var syncProcessingText:String = ""
    @Published var syncResponseMessage:String = ""
    @Published var syncResponseSuccess:Bool = false
    
    //MARK: let Properties
    private let dismissView = PassthroughSubject<Void, Never>()
    private let serviceObj:Services
    private let syncDataFunctionalityObj = SyncDataFunctionality()

    //MARK: var Properties
    var completeService:Bool = false
    var dismissRequest: AnyPublisher<Void, Never> {
        dismissView.eraseToAnyPublisher()
    }
    
    //MARK: Initialization
    init(serviceObj:Services){
        self.serviceObj = serviceObj
        self.checkUserActive = serviceObj.checkLoginStatus()
        self.user = serviceObj.getUserDetails()
    }
 
    //MARK: Functions
    func profileOnAppearView(){
        loader = false
        completeService = false
        loginAlert = false
        getUserLiveData()
    }
    
    func timeout(){
        var runCount = 0
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            runCount += 1

            if runCount == 10 {
                timer.invalidate()
                if !self.completeService {
                    self.loginAlert = true
                    self.alertText = "An error occured. Please try again later!"
                    self.completeService = true
                    self.loader = false
                }
                
            }
        }
    }
    
    func login() {
        alertText = ""
        loader = false
        if email.isEmpty || password.isEmpty {
            loginAlert = true
            if email.isEmpty && password.isEmpty {
                alertText = "E-mail and Password are required"
            }else{
                if email.isEmpty {
                    alertText = "E-mail is required"
                }
                if password.isEmpty {
                    alertText = "Password is required"
                }
            }
        }
        else{
            completeService = false
            loader = true
            serviceObj.login(credentials: email, credentials: password,credentials: nil){ loginResponse in
                DispatchQueue.main.async {
                    if let response = loginResponse {
                        if !response.connectionError!{
                            self.checkUserActive = self.serviceObj.loginStatus
                            if self.checkUserActive {
                                self.loginAlert = false
                                self.user = self.serviceObj.getUserDetails()
                            }
                            else{
                                self.loginAlert = true
                                self.alertText = "Incorrect E-mail or Password"
                            }
                        }
                        else{
                            self.loginAlert = true
                            self.alertText = "An error occured. Please try again later!"
                        }
                        self.completeService = true
                        self.loader = false
                    }
                }
            }
        }
    }
    
    func register(_ email:String,_ password:String,_ repeatPassword:String,_ firstName:String,_ surName:String){
        alertText = ""
        loader = false

        if email.isEmpty || password.isEmpty {
            loginAlert = true
            if email.isEmpty && password.isEmpty {
                alertText = "E-mail and Password are required"
            }
            else{
                if email.isEmpty {
                    alertText = "E-mail is required"
                }
                if password.isEmpty {
                    alertText = "Password is required"
                }
            }
        }
        else{
            if password != repeatPassword {
                loginAlert = true
                alertText = "Passwords do not match"
            }
            else{
                completeService = false
                loader = true
                serviceObj.register(credentials: email, credentials: password, info: firstName, info: surName,info: nil){
                    registerResponse in
                    DispatchQueue.main.async {
                        if !registerResponse.connectionError! {
                            self.checkUserActive = self.serviceObj.loginStatus
                            if self.checkUserActive {
                                self.loginAlert = false
                                self.user = self.serviceObj.getUserDetails()
                            }else{
                                self.loginAlert = true
                                self.alertText = registerResponse.message ??
                                "An error occured. Please try again later!"
                            }
                        }
                        else{
                            self.loginAlert = true
                            self.alertText = "An error occured. Please try again later!"
                        }
                        self.loader = false
                        self.completeService = true
                    }
                }
            }
        }
    }
    
    func refreshUserData(_ email:String,_ currentPassword:String,_ newPassword:String,_ repeatPassword:String,_ firstName:String,_ surName:String){
        loader = false
        if newPassword != repeatPassword {
            loginAlert = true
            alertText = "Passwords do not match"
        }
        else{
            completeService = false
            loader = true
            serviceObj.register(credentials: email, credentials: currentPassword, info: firstName, info: surName,info: newPassword){
                registerResponse in
                DispatchQueue.main.async {
                    if !registerResponse.connectionError!{
                        if registerResponse.success {
                            self.loginAlert = false
                            self.user = self.serviceObj.getUserDetails()
                            self.dismissView.send()
                        }
                        else{
                            self.loginAlert = true
                            self.alertText = registerResponse.message ??
                            "An error occured. Please try again later!"
                        }
                    }
                    else{
                        self.loginAlert = true
                        self.alertText = "An error occured. Please try again later!"
                    }
                    self.loader = false
                    self.completeService = true
                }
            }
        }
    }
    
    func getUserLiveData(){
        completeService = false
        freezeScreen = true
        serviceObj.login(credentials: user.email, credentials: "",credentials: user.id){ loginResponse in
            DispatchQueue.main.async {
                if !loginResponse!.connectionError! {
                    self.checkUserActive = self.serviceObj.loginStatus
                    if self.checkUserActive {
                        self.loginAlert = false
                        self.user = self.serviceObj.getUserDetails()
                    }
                    self.freezeScreen = false
                }
                else{
                    self.loginAlert = true
                    self.alertText = "An error occured. Please try again later!"
                }
                self.loader = false
                self.completeService = true
            }
        }
    }
    
    func logout(){
        serviceObj.logout(){
            DispatchQueue.main.async {
                self.checkUserActive = false
            }
        }
    }
    
    func deleteAccount(){
        completeService = false
        loader = true
        serviceObj.deleteAccount(user.id,user.email){
            deleteResponse in
            DispatchQueue.main.async {
                if deleteResponse!.connectionError!{
                    self.loginAlert = true
                    self.alertText = "An error occured. Please try again later!"
                    self.completeService = true
                    self.loader = false
                }
                else{
                    if deleteResponse!.success{
                        self.loader = false
                        self.completeService = true
                        self.navigationToSyncDataView = true
                        self.dismissView.send()
                        self.logout()
                    }else{
                        self.loginAlert = true
                        self.alertText = "An error occured. Please try again later!"
                        self.completeService = true
                        self.loader = false
                    }
                }
            }
        }
    }
    
    func initializeSyncResponses(){
        syncProcessingText="Processing..."
        showDatabaseProgress = true
        syncResponseMessage = ""
        syncResponseSuccess = false
    }
    
    func uploadAllDatabases(){
        initializeSyncResponses()
        syncDataFunctionalityObj.uploadRealmDatabaseToServer(id:user.id,email:user.email){
            response in
            self.syncResponseMessage = response.message
            self.syncResponseSuccess = response.success
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.showDatabaseProgress = false
            }
        }
    }
    
    func downloadAllDatabases(){
        initializeSyncResponses()
        syncDataFunctionalityObj.downloadRealmDatabaseFromServer(id:user.id,email:user.email){
              response in
            self.syncResponseMessage = response.message
            self.syncResponseSuccess = response.success
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.showDatabaseProgress = false
            }
        }
    }
}
