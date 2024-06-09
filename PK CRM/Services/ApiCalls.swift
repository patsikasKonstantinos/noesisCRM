//
//  ApiCalls.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 29/6/23.
//

import Foundation

class ApiCalls:ApiCallsProtocol{
    
    //MARK: Initialization
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
     
    //MARK: Login
    func callApiLogin(_ url:URL,switch service:Int,_ email:String, _ password:String,_ id:Int?, completion: @escaping (LoginResponse?) -> Void){
        var loginResponseObj = LoginResponse(success: false,connectionError: true)
        
        let json: [String: Any] = [
            "id":id ?? 0,
            "email": "\(email)",
            "password": "\(password)",
        ]
        
        // Convert the JSON data to Data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else {
            print("Failed to convert JSON to Data")
            completion(loginResponseObj)
            return
        }
        
        guard let url = URL(string: "\(Variables.loginUrlApi)") else {
            print("Invalid URL")
            completion(loginResponseObj)

            return
        }
        
        var request = URLRequest(url: url)
        
        // Set the HTTP method to POST
        request.httpMethod = "POST"

        // Set the request body with the JSON data
        request.httpBody = jsonData

        // Set the Content-Type header to application/json
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

          // Create a URLSession instance
        let session = URLSession.shared
          
        // Create a data task using the URL
        let task = session.dataTask(with: request) { (data, response, error) in
              // Check for any errors
              if let error = error {
                  print("Error: \(error.localizedDescription)")
                  completion(loginResponseObj)
                  return
              }
              
              // Ensure that we have received a response
              guard let httpResponse = response as? HTTPURLResponse else {
                  print("Invalid response")
                  completion(loginResponseObj)
                  return
              }
              
              // Check the response status code
              if httpResponse.statusCode == 200 {
                  // Ensure that we have received data
                  guard let jsonData = data else {
                      completion(loginResponseObj)
                      return
                  }
 
                  do {
                      
                      // Parse the JSON data
                      let myData = try self.decoder.decode(LoginResponse.self, from: jsonData)
                      if myData.success {
                          loginResponseObj = LoginResponse(success: myData.success, id: myData.id, name: myData.name!, surname: myData.surname!, email: myData.email!,connectionError: false)
                      }
                      else{
                          loginResponseObj = LoginResponse(success: myData.success,connectionError: false)
                      }
                      completion(loginResponseObj)
                  }
                  catch {
                      loginResponseObj = LoginResponse(success: false,connectionError:true)
                      completion(loginResponseObj)
                      print(String(describing: error)) // <- ✅ Use this for debuging!
                  }
              }
            else {
                  loginResponseObj = LoginResponse(success: false,connectionError:true)
                  completion(loginResponseObj)
                  print("HTTP Response Error - Status code: \(httpResponse.statusCode)")
              }
        }
        // Start the data task
        task.resume()
    }
    
    func login(credentials email:String,credentials password:String,credentials id:Int?,completion: @escaping (LoginResponse?) -> Void) {
        callApiLogin(URL(string: Variables.loginUrlApi)!, switch: 1,email,password,id){ loginResponse in
            
            if loginResponse!.success {
                
                // Create an instance of user object
                let user = Users(
                    id: loginResponse!.id ?? 0,
                    email: loginResponse!.email ?? "",
                    name: loginResponse!.name ?? "",
                    surname: loginResponse!.surname ?? ""
                )
                self.storeUserData(user)
            }
            completion(loginResponse)
        }
    }
    
    func checkLoginStatus()->Bool{
        let user =  getUserDetails()
        if user.id > 0 {
            return true
        }
        else{
            return false
        }
    }
         
    //MARK: Store and Retrieve Users Data
    func storeUserData(_ user:Users){
        
        // Encode the object as data
        if let encodedData = try? encoder.encode(user) {
            do {
                try encodedData.write(to: Variables.userFileManagereURL)
            }
            catch {
                print("Failed to write data to file: \(error)")
            }
        }
    }
    
    func getUserDetails()->Users{
        var user = Users(
            id: 0,
            email: "",
            name: "",
            surname:  ""
        )
        
        // Read the data from file
        if let savedData = try? Data(contentsOf: Variables.userFileManagereURL) {
            // Decode the data back into a custom object
            if let decodedObject = try? decoder.decode(Users.self, from: savedData) {
                user = Users(
                    id: decodedObject.id,
                    email: decodedObject.email,
                    name: decodedObject.name,
                    surname: decodedObject.surname
                )
            }
        }
        return user
    }
    
    //MARK: Logout
    func logout(completion: () -> Void){
        do {
            try FileManager.default.removeItem(at: Variables.userFileManagereURL)
            print("File deleted successfully.")
        }
        catch {
            print("Failed to delete file: \(error)")
        }
        completion()
    }
    
    //MARK: Register
    func callApiRegister(_ url:URL,switch service:Int,_ email:String, _ password:String,
                         _ name:String,_ surname:String,_ newPassword:String?,completion: @escaping (RegisterResponse?) -> Void){
        var registerResponseObj = RegisterResponse(success: false,connectionError: true)
        let currLoggedUserId = getUserDetails().id
        let json: [String: Any] = [
            "id":currLoggedUserId,
            "email": "\(email)",
            "password": "\(password)",
            "newPassword": newPassword ?? "",
            "name":"\(name)",
            "surname":"\(surname)",
        ]
        
        // Convert the JSON data to Data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else {
            print("Failed to convert JSON to Data")
            completion(registerResponseObj)
            return
        }
 
        guard let url = URL(string: "\(Variables.registerUrlApi)") else {
            print("Invalid URL")
            completion(registerResponseObj)
            return
        }
        
        var request = URLRequest(url: url)

        // Set the HTTP method to POST
        request.httpMethod = "POST"

        // Set the request body with the JSON data
        request.httpBody = jsonData

        // Set the Content-Type header to application/json
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

          // Create a URLSession instance
        let session = URLSession.shared
          
          // Create a data task using the URL
        let task = session.dataTask(with: request) { (data, response, error) in
              // Check for any errors
              if let error = error {
                  print("Error: \(error.localizedDescription)")
                  completion(registerResponseObj)
                  return
              }
              
              // Ensure that we have received a response
              guard let httpResponse = response as? HTTPURLResponse else {
                  print("Invalid response")
                  completion(registerResponseObj)
                  return
              }
              
              // Check the response status code
              if httpResponse.statusCode == 200 {
                  // Ensure that we have received data
                  guard let jsonData = data else {
                      completion(registerResponseObj)
                      return
                  }
                  
 
                  do {
                      // Parse the JSON data
                      let myData = try self.decoder.decode(RegisterResponse.self, from: jsonData)
                      if myData.success {
                          registerResponseObj = RegisterResponse(success: myData.success, id: myData.id, name: myData.name!, surname: myData.surname!, email: myData.email!,message: myData.message,connectionError: false)
                      }
                      else{
                          registerResponseObj = RegisterResponse(success: myData.success,message: myData.message,connectionError: false)
                      }
                      completion(registerResponseObj)
 
                      
                  }
                  catch {
                      print(String(describing: error)) // <- ✅ Use this for debuging!
                      completion(registerResponseObj)
                  }
              }
            else {
                  print("HTTP Response Error - Status code: \(httpResponse.statusCode)")
                  completion(registerResponseObj)
              }
          }
          // Start the data task
          task.resume()
    }
    
    func register(credentials email:String,credentials password:String,info firstName:String,
                  info lastName:String,info newPassword:String?,completion: @escaping (RegisterResponse?) -> Void){
        callApiRegister(URL(string: Variables.registerUrlApi)!, switch: 1,email,password,firstName,lastName,newPassword){ registerResponse in

            if registerResponse!.success {
                
                // Create an instance of user object
                let user = Users(
                    id: registerResponse!.id ?? 0,
                    email: registerResponse!.email ?? "",
                    name: registerResponse!.name ?? "",
                    surname: registerResponse!.surname ?? ""
                )

                self.storeUserData(user)
            }
            completion(registerResponse)
        }
    }
    
    //MARK: Delete Users
    func callApiDelete(_ id:Int,_ email:String, completion: @escaping (DeleteResponse?) -> Void){
        var deleteResponseObj = DeleteResponse(success: false,connectionError: true)
        let json: [String: Any] = [
            "id":id,
            "email": "\(email)"
        ]
        
        // Convert the JSON data to Data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else {
            completion(deleteResponseObj)
            return
        }
        guard let url = URL(string: "\(Variables.deleteUrlApi)") else {
            completion(deleteResponseObj)
            return
        }
        
        var request = URLRequest(url: url)

        // Set the HTTP method to POST
        request.httpMethod = "POST"

        // Set the request body with the JSON data
        request.httpBody = jsonData

        // Set the Content-Type header to application/json
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

          // Create a URLSession instance
        let session = URLSession.shared
          
          // Create a data task using the URL
        let task = session.dataTask(with: request) { (data, response, error) in
              // Check for any errors
              if let error = error {
                  print("Error: \(error.localizedDescription)")
                  completion(deleteResponseObj)
                  return
              }
              
              // Ensure that we have received a response
              guard let httpResponse = response as? HTTPURLResponse else {
                  print("Invalid response")
                  completion(deleteResponseObj)
                  return
              }
              
              // Check the response status code
              if httpResponse.statusCode == 200 {
                  // Ensure that we have received data
                  guard let jsonData = data else {
                      completion(deleteResponseObj)
                      return
                  }
                  
                  do {
                      // Parse the JSON data
                      let myData = try self.decoder.decode(DeleteResponse.self, from: jsonData)
                      deleteResponseObj = DeleteResponse(success: myData.success,connectionError: false)
                      completion(deleteResponseObj)
                  }
                  catch {
                      print(String(describing: error)) // <- ✅ Use this for debuging!
                      completion(deleteResponseObj)
                  }
              }
            else {
                  print("HTTP Response Error - Status code: \(httpResponse.statusCode)")
                  completion(deleteResponseObj)
              }
         }
        // Start the data task
        task.resume()
    }
    
    func deleteAccount(_ id:Int,_ email:String,completion: @escaping (DeleteResponse?) -> Void){
        callApiDelete(id,email){ deleteResponse in
            completion(deleteResponse)
        }
    }
    
    func forgotPassword(credentials email:String){
    }
}
