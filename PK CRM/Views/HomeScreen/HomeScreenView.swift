//
//  HomeScreenView.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 31/12/22.
//

import SwiftUI

struct HomeScreenView: View {
    
    //MARK: Variables
    @EnvironmentObject var settingsViewModel: SettingsViewModel

    //MARK: Body
    var body: some View {
        GeometryReader { geometry in
            ScrollView(showsIndicators: false){
                VStack{
                    VStack{
                        ZStack{
                            GradientBackgroundView(
                                color: AppColors.redOpacity03.swiftUIColor, points: (startPoint:.top,endPoint:.bottom)
                            )
                             
                            HStack{
                                VStack(alignment: .leading){
                                    HStack{
                                        VStack{
                                            Image(systemName: "person")
                                                .resizable()
                                                .homePageViewImagesStyle()
                                               
                                            Text("Contacts")
                                                .font(.system(size: 19))
                                        }
                                       
                                        VerticalLineView()

                                        VStack{
                                            HStack{
                                                Text("Customers")
                                                    .font(.system(size:14))
                                                
                                                Spacer()
                                                
                                                Text("\(settingsViewModel.contacts.customers)")
                                                    .fontWeight(.bold)
                                                    .font(.system(size:14))
                                                
                                            }
                                            .padding(.top,5)
                                            
                                            HStack{
                                                Text("Suppliers")
                                                    .font(.system(size:14))
                                                
                                                Spacer()
                                                
                                                Text("\(settingsViewModel.contacts.suppliers)")
                                                    .fontWeight(.bold)
                                                    .font(.system(size:14))
                                            }
                                            
                                            HStack{
                                                Text("Empoyees")
                                                    .font(.system(size:14))
                                                
                                                Spacer()
                                                
                                                Text("\(settingsViewModel.contacts.employees)")
                                                    .fontWeight(.bold)
                                                    .font(.system(size:14))
                                            }
                                        }
                                    }
                                }
                            }
                            .homePageViewHstackStyle(290,nil)
                        }
                        .whiteBackgroundWithRadius()
                        .frame(maxHeight:120)
      
                        ZStack{
                            GradientBackgroundView(
                                color:AppColors.indigoOpacity02.swiftUIColor, points: (startPoint:.bottomLeading,endPoint:.topTrailing)
                            )
                            
                            VStack(alignment: .leading){
                                HStack{
                                    Image(systemName: "pencil.slash")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 25,height: 25)
                                    
                                    Text("Projects")
                                        .font(.system(size: 19))
                                }
                                .frame(height: 20)
                                
                                Picker("Status", selection: $settingsViewModel.selectedProjectStatus) {
                                    Text("Opened").tag(1)
                                    
                                    Text("All").tag(0)
                                }
                                .pickerStyle(.segmented)
                                
                                if settingsViewModel.projects.count == 0 {
                                    HStack{
                                        Spacer()
                                        Text("Projects Not Found")
                                            .font(.system(size: 15))
                                        Spacer()
                                    }
                                    .padding(.vertical,5)
                    
                                }else{

                                    ScrollView(.horizontal,showsIndicators: false) {
                                        HStack{
                                            ForEach (settingsViewModel.projects) { project in
                                                ZStack {
                                                    GradientBackgroundView(color: settingsViewModel.findProjectStatusColor(project.status).swiftUIColor, points: (startPoint:.top,endPoint:.bottom))
                                                    
                                                    ProjectsListViewItem(project: project)
                                                         .homePageProjects(width: 250)
                                                }
                                            }
                                        }
                                        .padding(.vertical,10)
                                    }
                                    .padding(EdgeInsets(top: 5, leading: 5, bottom:5, trailing: 5))
                                    .background(.white.opacity(0.5))
                                    .cornerRadius(10)
                                    
                                }
                            }
                            .homePageViewHstackStyle(290,settingsViewModel.projects.count == 0 ? 80 : 300)
                        }
                        .whiteBackgroundWithRadius()
                        .frame(maxHeight:settingsViewModel.projects.count == 0 ? 130 : 350)
                        
                        HStack{
                            ZStack{
                                GradientBackgroundView(
                                    color:Color(red: 224/255, green: 224/255, blue: 224/255),points:(startPoint:.bottomLeading,endPoint:.topTrailing)
                                )
                                
                                VStack {
                                    HStack(alignment:.center){
                                        Image(systemName: "phone")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 25,height: 25)
                                        
                                        Text("Calls")
                                            .font(.system(size: 19))
                                    }
                                    .frame(height: 35,alignment:.center)
                                     
                                    HorizontalLineView()
                                 
                                    HStack{
                                        Text("Num.")
                                            .font(.system(size:14))
                                        
                                        Spacer()
                                        
                                        Text("\(settingsViewModel.callsCount)")
                                            .fontWeight(.bold)
                                            .font(.system(size:14))
                                    }
                                    .padding(.top,2)
                                }
                                .homePageViewHstackStyle(125,nil)
                            }
                            .whiteBackgroundWithRadius()
                          
                            ZStack{
                                GradientBackgroundView(color: AppColors.orangeOpacity03.swiftUIColor,points:(startPoint:.bottomLeading,endPoint:.topTrailing)
                                )
                                
                                HStack{
                                    VStack{
                                        HStack{
                                            Image(systemName: "person.line.dotted.person.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 35,height: 35)
                                            
                                            Text("Meetings")
                                                .font(.system(size: 19))
                                        }
                                        .frame(height: 35)
                                        
                                        HorizontalLineView()
                                        
                                        HStack{
                                            Text("\(settingsViewModel.currentDay.monthShort) \(settingsViewModel.currentDay.year)")
                                                .font(.system(size:14))
                                            
                                            Spacer()
                                            
                                            Text("\(settingsViewModel.filteredMeetingsCount)")
                                                .fontWeight(.bold)
                                                .font(.system(size:14))
                                        }
                                        .padding(.top,2)
                                    }
                                }
                                .homePageViewHstackStyle(125,nil)
                            }
                            .whiteBackgroundWithRadius()
                        }
                        .frame(maxHeight:100)
                        
                        HStack{
                            ZStack{
                                GradientBackgroundView(color: AppColors.greenOpacity03.swiftUIColor,points:(startPoint:.bottomLeading,endPoint:.topTrailing)
                                )
                                
                                HStack{
                                    VStack{
                                        HStack{
                                            Image("income")
                                                .resizable()
                                                .homePageViewImagesStyle()
                                            
                                            VStack{
                                                Text("Incomes")
                                                    .font(.system(size: 19))
                                                
                                                Text("\(settingsViewModel.currentDay.monthShort) \(settingsViewModel.currentDay.year)")
                                                    .font(.system(size:14))
                                            }
                                        }
                                        .frame(height: 35)
                                        
                                        HorizontalLineView()
                                        
                                        HStack{
                                            Text("Amount")
                                                .font(.system(size:14))
                                            
                                            Spacer()
                                            
                                            Text("\(settingsViewModel.filteredIncomes) \(Variables.currency)")
                                                .fontWeight(.bold)
                                                .font(.system(size:14))
                                        }
                                        .padding(.top,2)
                                    }
                                }
                                .homePageViewHstackStyle(125,nil)
                            }
                            .whiteBackgroundWithRadius()

                            ZStack{
                                GradientBackgroundView(color: Color(red: 1, green: 182/255, blue: 193/255),points:(startPoint:.bottomLeading,endPoint:.topTrailing)
                                )
                                
                                HStack{
                                    VStack{
                                        HStack{
                                            Image("expenses")
                                                .resizable()
                                                .homePageViewImagesStyle()
                                            
                                            VStack{
                                                Text("Expenses")
                                                    .font(.system(size: 19))
                                                
                                                Text("\(settingsViewModel.currentDay.monthShort) \(settingsViewModel.currentDay.year)")
                                                    .font(.system(size:14))
                                            }
                                        }
                                        .frame(height: 35)
                                        
                                        HorizontalLineView()
                                        
                                        HStack{
                                            Text("Amount")
                                                .font(.system(size:14))

                                            Spacer()
                                            
                                            Text("\(settingsViewModel.filteredExpenses) \(Variables.currency)")
                                                .fontWeight(.bold)
                                                .font(.system(size:14))
                                        }
                                        .padding(.top,2)
                                    }
                 
                                }
                                .homePageViewHstackStyle(125,nil)
                            }
                            .whiteBackgroundWithRadius()
                        }
                        .frame(maxHeight:100)

                        ZStack{
                            GradientBackgroundView(color: AppColors.blueOpacity03.swiftUIColor,points:(startPoint:.bottomLeading,endPoint:.topTrailing)
                            )
                         
                            HStack{
                                VStack{
                                    Image(systemName: "text.and.command.macwindow")
                                        .resizable()
                                        .homePageViewImagesStyle()
                                    
                                    Text("Collections")
                                        .font(.system(size: 19))
                                }
                                .padding(.horizontal,15)
                                
                                VerticalLineView()
                         
                                VStack{
                                    
                                    if settingsViewModel.allDynamicForms.count > 0 {
                                        GeometryReader { GeometryReaderCollection in
                                            ScrollView(.vertical,showsIndicators: false){
                                                VStack{
                                                    HStack{
                                                        Text("Name")
                                                            .fontWeight(.bold)
                                                            .font(.system(size:14))
                                                        
                                                        Spacer()
                                                    }
                                                    .padding(.bottom,2)
                                                    
                                                    ForEach(settingsViewModel.dynamicForms) { collection in
                                                        HStack{
                                                            Text("\(collection.name)")
                                                                .font(.system(size:14))
                                                            
                                                            Spacer()
                                                            
                                                            Text(collection.isEmpty ? "0" : "\(collection.entries.count)")
                                                                .font(.system(size:14))
                                                        }
                                                    }
                                                }
                                                .frame(minHeight:GeometryReaderCollection.size.height)
                                                .padding(.leading,10)
                                                .padding(.trailing,15)
                                            }
                                        }
                                        
                                    }else{
                                        
                                        HStack{
                                            Spacer()
                                            
                                            Text("Collections Not Found")
                                                .multilineTextAlignment(.center)
                                                .font(.system(size: 15))
                                            
                                            Spacer()
                                        }
                                    }
                                }
                            }
                            .homePageViewHstackStyle(120,settingsViewModel.allDynamicForms.count == 0 ? nil :100 )
                        }
                        .whiteBackgroundWithRadius()
                        .frame(maxHeight:130)
                    }
                    .padding(15)
                    .background(.white)
                    .cornerRadius(15)

                }
                .frame(maxWidth:750,minHeight: geometry.size.height)
                .padding(.vertical)
            }
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .padding(.horizontal,15)
            .background(settingsViewModel.appAppearance.themeBackgroundColor)
        }
    }
}
