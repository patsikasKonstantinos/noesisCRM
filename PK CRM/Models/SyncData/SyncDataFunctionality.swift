//
//  SyncDataFunctionality.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 28/2/23.
//

import Foundation
import Alamofire
import RealmSwift
import CryptoKit

class SyncDataFunctionality{
    
    //MARK: Properties
    let realm = RealmManager.shared.realm
    var sychronizeResponse:SychronizeResponse = SychronizeResponse(
        success: false, message: ""
    )
    
    //MARK: Functions
    func hashRealmFileName(_ id:Int,_ email:String)->String{
         let emailWithId = email + "@\(id)"
         let inputData = Data(emailWithId.utf8)
         let hashedData = SHA512.hash(data: inputData)
         let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
         let hashDirectory = String(hashString.prefix(20))
         return hashDirectory
    }
    
    func uploadRealmDatabaseToServer(id userId:Int, email Useremail:String ,completion:@escaping(SychronizeResponse)->Void){
        // Get the path to the exported Realm file
        RealmDatabaseLocalAndImportIt()
        let realmFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("exportedPK_CRM.realm")

        // Read the Realm file data
        let realmFileData = try! Data(contentsOf: realmFileURL)

        // Set the server URL to upload the file to
        let serverURL = "https://www.flogitarooms.gr/pk_crm/api/getRealmFile.php?id=\(userId)&email="+Useremail

        // Send the file to the server using Alamofire
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(realmFileData, withName: "file", fileName: "exportedPK_CRM.realm", mimeType: "application/octet-stream")
        }, to: serverURL).responseString { response in
            switch response.result {
            case .success(let value):
                print("File uploaded successfully")
                print("Server response: \(value)")
                self.sychronizeResponse.success = true
                self.sychronizeResponse.message = "Database has been successfully exported!"
            
            case .failure(let error):
                print("Error uploading file: \(error.localizedDescription)")
                self.sychronizeResponse.success = false
                self.sychronizeResponse.message = "Error exporting database"
                
            }
            completion(self.sychronizeResponse)
        }
    }
    func deleteRealmFile(fileName: String) {
       do {
           // Get the documents directory URL
           let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

           // Construct the full file URL for the Realm file
           let realmFileURL = documentsDirectoryURL.appendingPathComponent(fileName)

           // Close any open Realm instances before deleting the file
           Realm.Configuration.defaultConfiguration = Realm.Configuration()

           // Delete the Realm file from the file system
           try FileManager.default.removeItem(at: realmFileURL)
           print("Realm file '\(fileName)' deleted successfully.")
       }
       catch {
           // Handle error if the Realm file cannot be deleted
           print("there is not file: \(error)")
       }
    }
    
    func downloadRealmDatabaseFromServer(id userId:Int, email Useremail:String ,completion:@escaping(SychronizeResponse)->Void){
        // Set the server URL to download the file from
        let hashRealmFileName = hashRealmFileName(userId,Useremail)
        let serverURL = "https://www.flogitarooms.gr/pk_crm/realmFiles/\(hashRealmFileName)/exportedPK_CRM.realm?timestamp=\(Date().currentTimeMillis())"
        print("serverURL \(serverURL)")
        // Set the destination URL to save the downloaded file to
        let destinationURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("importedPK_CRM.realm")

        // Download the file from the server using Alamofire
        AF.download(serverURL, to: { _, _ in (destinationURL, [.removePreviousFile, .createIntermediateDirectories]) }).response { response in
            
            if response.error == nil, let filePath = response.fileURL?.path {
                // File downloaded successfully
                print("File downloaded successfully at path: \(filePath)")
                // Use Realm to open the downloaded database file
                do {
                    let realmFile = try Realm(fileURL: destinationURL)
                    self.sychronizeResponse.success = true
                    self.sychronizeResponse.message = "Database has been successfully imported!"
                    var objectTypes = realmFile.schema.objectSchema.map { $0.className }
                   
                    if objectTypes.count > 0 {
    
                        if objectTypes.contains("ContactsCustomObj"){
                            objectTypes = objectTypes.filter { $0 != "ContactsCustomObj" }
                            objectTypes.append("ContactsCustomObj")
                        }
                        
                        if objectTypes.contains("ProjectsCustomObj"){
                            objectTypes = objectTypes.filter { $0 != "ProjectsCustomObj" }
                            objectTypes.append("ProjectsCustomObj")
                        }
                        
                        if objectTypes.contains("TasksCustomObj"){
                            objectTypes = objectTypes.filter { $0 != "TasksCustomObj" }
                            objectTypes.append("TasksCustomObj")
                        }
                        
                        if objectTypes.contains("DynamicFormsFieldsValue"){
                            objectTypes = objectTypes.filter { $0 != "DynamicFormsFieldsValue" }
                            objectTypes.append("DynamicFormsFieldsValue")
                        }
                        
                        if objectTypes.contains("DynamicFormsFields"){
                            objectTypes = objectTypes.filter { $0 != "DynamicFormsFields" }
                            objectTypes.append("DynamicFormsFields")
                        }
                        
                        if objectTypes.contains("DynamicFormsEntries"){
                            objectTypes = objectTypes.filter { $0 != "DynamicFormsEntries" }
                            objectTypes.append("DynamicFormsEntries")
                        }
                        
                        if objectTypes.contains("DynamicForms"){
                            objectTypes = objectTypes.filter { $0 != "DynamicForms" }
                            objectTypes.append("DynamicForms")
                        }

                    }
                    
                    for className in objectTypes {
                        let namespace = (Bundle.main.infoDictionary!["CFBundleExecutable"] as! String).replacingOccurrences(of: " ", with: "_")
                        let cls: AnyClass = NSClassFromString("\(namespace).\(className)")!

                        // Make sure the class type is a subclass of Realm's Object class
                        guard let realmObjectClass = cls as? Object.Type else {
                            print("\(className) is not a subclass of Realm's Object class.")
                            return
                        }
 
                        // Retrieve all entries of the specified class
                        let allRealmObjects = realmFile.objects(realmObjectClass)
 
                        do {
                            try! self.realm.write {
                                for object in allRealmObjects {
                                    
                                    self.realm.create(realmObjectClass.self, value: object,update: .all)
                                }
                            }
                        }
                    }
                    // Use the Realm database
                }
                catch let error {
                    self.sychronizeResponse.success = false
                    self.sychronizeResponse.message = "No backup available!"
                    print("Error opening Realm database: \(error.localizedDescription)")
                }
            } else {
                // Error downloading file
                self.sychronizeResponse.success = false
                self.sychronizeResponse.message = "An error Occured.Please try again later!"
                print("Error downloading file:  \(response.error?.localizedDescription) ?? Unknown error")
            }
            completion(self.sychronizeResponse)
        }
    }
 
    func clearDownloadedRealmFiles() {
        let fileManager = FileManager.default
        do {
            let documentDirectoryURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let realmFiles = try fileManager.contentsOfDirectory(at: documentDirectoryURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for realmFile in realmFiles {
                if realmFile.pathExtension.lowercased() == "realm" {
                    try fileManager.removeItem(at: realmFile)
                    print("Deleted Realm file: \(realmFile.lastPathComponent)")
                }
            }
        } catch {
            print("Error clearing downloaded Realm files: \(error.localizedDescription)")
        }
    }
    func RealmDatabaseLocalAndImportIt(){
        // Open the Realm database
        //let realm = RealmManager.shared.realm
        print("ready for upload")
        // Define the file URL for the exported database
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let exportedDatabaseURL = documentsDirectoryURL.appendingPathComponent("exportedPK_CRM.realm")
        deleteRealmFile(fileName: "exportedPK_CRM.realm")
        try! self.realm.writeCopy(toFile: exportedDatabaseURL)
        print("exportedDatabaseURL \(exportedDatabaseURL)")

//        // Export the database if the file already exists
//        if !FileManager.default.fileExists(atPath: exportedDatabaseURL.path) {
//            //EXPORT FIRST TIME
//            try! self.realm.writeCopy(toFile: exportedDatabaseURL)
//        } else {
//            print("Failed: file exist at \(exportedDatabaseURL.path)")
//
//            //EXPORT NEW FILE
////            try! FileManager.default.removeItem(at: exportedDatabaseURL)
////            try! realm.writeCopy(toFile: exportedDatabaseURL)
//
//
//            //DELETE
////            let realm2 = try! Realm()
////            let allExistedContactsObjects = self.realm.objects(Contacts.self)
////            try! self.realm.write {
////                self.realm.delete(allExistedContactsObjects)
////            }
//
//
//            //RETRIEVE DATABASE FROM FILE
//            let fileURL = URL(fileURLWithPath: exportedDatabaseURL.path)
//            let realmFile = try! Realm(fileURL: fileURL)
//            let contacts = realmFile.objects(Contacts.self)
//
//
//
//            print("existed contacts \(contacts)")
//            //Existeed database
//
//            try! realmFile.write {
//                for contact in contacts {
//                    realmFile.create(Contacts.self, value: contact,update: .all)
//                }
//            }
//
//
            
 //       }
    }
}
