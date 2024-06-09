//
//  ContactDetailsView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 12/6/23.
//

import SwiftUI

extension ContactView {
    
    func contactDetailsView() -> some View {
        
        return List {
            ForEach(0..<viewModel.listViewItems.count, id: \.self) { index in
                HStack {
                    if index == 1 {
                        Text("\(viewModel.listViewItems[index]!.name):")
                            .foregroundColor(viewModel.filledName ? Color.black.opacity(0.6) : Color.red)
                            .font(.system(size: 16))
                    } else if index == 2 {
                        Text("\(viewModel.listViewItems[index]!.name):")
                            .foregroundColor(viewModel.filledSurname ? Color.black.opacity(0.6) : Color.red)
                            .font(.system(size: 16))
                    } else {
                        Text("\(viewModel.listViewItems[index]!.name):")
                            .foregroundColor(Color.black.opacity(0.6))
                            .font(.system(size: 16))
                    }
                    
                    if viewModel.listViewItems[index]!.type == 1 {
                        TextField("", text: $inputTextStringsController[index]) { isBegin in
                            if isBegin {
                                if index == 1 {
                                    viewModel.filledName = true
                                }
                                if index == 2 {
                                    viewModel.filledSurname = true
                                }
                            }
                        }
                    }
                    else if viewModel.listViewItems[index]!.type == 2 {
                        Toggle("", isOn: $viewModel.isActive)
                    }
                    else if viewModel.listViewItems[index]!.type == 3 {
                        
                        if index > 0 {
                            Picker(selection: $viewModel.countrySelection, label: Text("")) {
                                ForEach(0..<viewModel.countries.count, id: \.self) { countriesCount in
                                    Text("\(viewModel.countries[countriesCount]!)").tag(countriesCount)
                                }
                            }
                        } else {
                            Picker(selection: $viewModel.typeSelection, label: Text("")) {
                                ForEach(0..<viewModel.types.count, id: \.self) { typesCount in
                                    Text("\(viewModel.types[typesCount]!)").tag(typesCount)
                                }
                            }
                        }
                    }
                    else if viewModel.listViewItems[index]!.type == 4 {
                        TextField("", text: Binding(
                            get: { inputTextStringsController[index] },
                            set: { inputTextStringsController[index] = $0.filter { "0123456789".contains($0) } }
                        ))
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .frame(maxHeight: openedTab == 1 ? .infinity : 0)
        .opacity(openedTab == 1 ? 1 : 0)
    }
}
 
