//
//  PK_CRMApp.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 31/12/22.
//

import SwiftUI

@main
struct PK_CRMApp: App {
    
    //MARK: Properties
    @State var displaySplash = true
    @State private var timeElapsed: TimeInterval = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var viewModel = SettingsViewModel()

    //MARK: Body
    var body: some Scene {
        WindowGroup {
            
            if displaySplash {
                VStack{
                    Image("splash")
                        .resizable()
                        .scaledToFit()
                        .background(.white)
//                        .overlay( /// apply a rounded border
//                            RoundedRectangle(cornerRadius: 20)
//                                .stroke(.white.opacity(0.2), lineWidth: 10)
//                        )
                        .frame(maxWidth: 350,maxHeight: .infinity,alignment: .center)
                }
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .background(.black)
                .onReceive(timer) { _ in
                    self.timeElapsed += 1
                    if timeElapsed == 5 {
                        displaySplash = false
                    }
                }
            }
            else{
                MainTabView()
                    .environmentObject(viewModel)
                    .preferredColorScheme(.light) // or .dark

            }
        }
    }
}
