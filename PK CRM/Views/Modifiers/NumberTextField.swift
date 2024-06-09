//
//  NumberTextField.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 23/7/23.
//

import SwiftUI

struct NumberTextField: UIViewRepresentable {
    
    //MARK: Variables
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.keyboardType = .decimalPad
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: NumberTextField
        
        //MARK: Initialization
        init(_ parent: NumberTextField) {
            self.parent = parent
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let allowedCharacterSet = CharacterSet(charactersIn: "0123456789.")
            let replacementCharacterSet = CharacterSet(charactersIn: string)
            if !allowedCharacterSet.isSuperset(of: replacementCharacterSet) {
                return false
            }
            
            var newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            newText = newText.filter {
                allowedCharacterSet.contains($0.unicodeScalars.first!)
                
            }
            let components = newText.components(separatedBy: ".")
            if components.count > 2 {
                return false
            } else if components.count == 2 {
                let decimalPart = components[1]
                if decimalPart.count > 2 {
                    return false
                }
            }
            parent.text = newText
            return true
        }
    }
}
