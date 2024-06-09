//
//  RealmManager.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 26/4/23.
//

import Foundation
import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    var realm: Realm

    //MARK: Initialization
    private init() {
        do {
            realm = try Realm()
        } catch let error {
            fatalError("Failed to instantiate Realm with error: \(error.localizedDescription)")
        }
    }
    
    //MARK: Functions
    func realmImportFromFile(fileURL:URL){
        realm = try! Realm(fileURL: fileURL)
    }
}
