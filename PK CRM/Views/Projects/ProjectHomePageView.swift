//
//  ProjectHomePageView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 27/8/23.
//

import SwiftUI

struct ProjectHomePageView: View {
    
    //MARK: Variables
    let project:Projects
    
    //MARK: Body
    var body: some View {
        VStack{
            HStack(alignment: .center){
                Text("Code:")
                    .frame(width:50,alignment: .leading)
                    .padding(.leading,5)
                
                Text(project.code)
                    .frame(width:170,alignment: .leading)
                    .padding(.trailing,5)
             }
            .frame(height:20)
            .frame(maxWidth:.infinity)
             
            Divider()
                 
            HStack {
                Text("Title:")
                    .frame(width:50,alignment: .leading)
                    .padding(.leading,5)

                Text(project.title)
                    .frame(width:170,alignment: .leading)
                    .padding(.trailing,5)
            }
            .frame(maxWidth:.infinity)
            .frame(height:90)
            
            Divider()
            
            HStack(alignment: .center){
                Text("Start Date:")
                    .frame(width:120,alignment: .leading)
                    .padding(.leading,5)
                
                Text("\(project.startDate.day) \(project.startDate.monthShort) \(project.startDate.year)")
                    .frame(width:100,alignment: .leading)
                    .padding(.trailing,5)
            }
            .frame(maxWidth:.infinity)
            .frame(height:20)
            
            HStack(alignment: .center){
                Text("Finish Date:")
                    .frame(width:120,alignment: .leading)
                    .padding(.leading,5)
                
                Text("\(project.finishDate.day) \(project.finishDate.monthShort) \(project.finishDate.year)")
                    .frame(width:100,alignment: .leading)
                    .padding(.trailing,5)
            }
            .frame(maxWidth:.infinity)
            .frame(height:20)
         }
    }
}
