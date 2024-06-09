//
//  SyncDataLoader.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 16/6/23.
//

import SwiftUI

extension SyncDataView {
    
    func SyncDataLoader() -> some View {
        HStack{
            if viewModel.loader {
                ProgressView()
            }
        }
    }
}
