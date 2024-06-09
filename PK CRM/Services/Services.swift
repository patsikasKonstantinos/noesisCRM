//
//  Login.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 29/6/23.
//

import Foundation

class Services:ApiCalls{
    var loginStatus:Bool = false
    
    //MARK: Login
    override func login(credentials email: String, credentials password: String,credentials id:Int?,completion: @escaping (LoginResponse?) -> Void) {
        super.login(credentials: email, credentials: password,credentials: id){
            loginResponse in
            self.loginStatus = self.checkLoginStatus()
            completion(loginResponse)
        }
    }

    override func checkLoginStatus() ->Bool {
        super.checkLoginStatus()
    }
    
    //MARK: Register
    override func register(credentials email:String,credentials password:String,info firstName:String,info lastName:String,info newPassword:String?,completion: @escaping (RegisterResponse) -> Void) {
        super.register(credentials:email,credentials:password,info:firstName,info:lastName,info:newPassword){
            registerResponse in
            self.loginStatus = self.checkLoginStatus()
            completion(registerResponse!)
        }
    }
    
    //MARK: Store and Retrieve Users
    override func getUserDetails() -> Users {
        super.getUserDetails()
    }
    
    //MARK: Delete Users
    override func deleteAccount(_ id:Int,_ email:String,completion:@escaping  (DeleteResponse?) -> Void){
        super.deleteAccount(id,email){ deleteResponse in
            completion(deleteResponse)
        }
    }
    
    //MARK: Logout
    override func logout(completion: () -> Void){
        super.logout{
            completion()
        }
    }
}
