//
//  DeviceRotationViewModifier.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 28/8/23.
//

import SwiftUI

struct DeviceRotationViewModifier: ViewModifier {
    
    //MARK: Variables
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

// A View wrapper to make the modifier easier to use
extension View {
    
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}
