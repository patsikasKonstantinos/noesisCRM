//
//  TaskViewHeader.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 18/6/23.
//

import SwiftUI

extension TaskView{

    func TaskViewHeader()  -> some View {
        
        HStack{
            HStack{
                Text("Back")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        dismiss()
                    }
                
                Spacer()
                
                Text("Task Details")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("Save")
                    .foregroundColor(!showingAlertAnimation ? .blue : .blue.opacity(0.3))
                    .fontWeight(.bold)
                    .onTapGesture {
                        if !viewModel.showingAlert {
                            viewModel.saveTasks { success in
                                if success {
                                    tasksList = viewModel.tasksList
                                    dismiss()
                                }
                            }
                        }
                    }
              }
              .padding(.horizontal,15)
        }
        .frame(height: 60)
        .background(Color.white)
    }
}

 
