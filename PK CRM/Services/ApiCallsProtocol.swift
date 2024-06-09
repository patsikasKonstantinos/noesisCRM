//
//  ApiCalls.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 29/6/23.
//

import Foundation

protocol ApiCallsProtocol {
    
    //MARK: All Api Calls
    func callApiLogin(_ url:URL,switch service:Int,_ email:String, _ password:String,_ id:Int?,completion: @escaping (LoginResponse?) -> Void)
    
    func login(credentials email:String,credentials password:String,credentials id:Int?,  completion: @escaping (LoginResponse?) -> Void)
    
    func logout(completion: () -> Void)
     
    func register(credentials email:String,credentials password:String,info firstName:String,info lastName:String,info newPassword:String?,
                  completion: @escaping (RegisterResponse?) -> Void)
    
    func deleteAccount(_ id:Int,_ email:String, completion: @escaping (DeleteResponse?) -> Void)
    
    func forgotPassword(credentials email:String)
    
    func checkLoginStatus()->Bool
}
