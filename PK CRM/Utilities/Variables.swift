//
//  Variables.swift
//  PK CRM
//
//  Created by Κωνσταντίνος Πατσίκας on 1/1/23.
//

import Foundation
import SwiftUI

class Variables{
    
    //MARK: Static App Variables
    static let mainMenuListNames:[Int:String] = [
        0:"Financial Economics",
        1:"Reports",
        2:"Contacts",
        3:"Meetings",
        4:"Calls",
        5:"Days off",
        6:"Goal Settings",
        7:"Employee Evaluations",
        8:"Projects",
        9:"Tasks",
        10:"Custom Collections",
        11:"Sync",
        12:"Settings"
    ]
    
    static let contactViewListItems:[Int:ContactForm] =  [
        0:ContactForm(name: "Type", type: 3),
        1:ContactForm(name: "Name", type: 1),
        2:ContactForm(name: "Surname", type: 1),
        3:ContactForm(name: "Phone", type: 4),
        4:ContactForm(name: "Second Phone", type: 4),
        5:ContactForm(name: "Country", type: 3),
        6:ContactForm(name: "State", type: 1),
        7:ContactForm(name: "City", type: 1),
        8:ContactForm(name: "Address", type: 1),
        9:ContactForm(name: "Post Code", type: 1),
        10:ContactForm(name: "Tax Id", type: 1),
        11:ContactForm(name: "Identity Id", type: 1),
        12:ContactForm(name: "Active", type: 2),
    ]
    
    static let meetingViewListItems:[Int:MeetingForm] =  [
        0:MeetingForm(name: "Title", type: 1),
        1:MeetingForm(name: "Date", type: 5),
        2:MeetingForm(name: "Contacts", type: 6),
        3:MeetingForm(name: "Comments", type: 8),
        4:MeetingForm(name: "Completed", type: 2),
    ]
     
    static let callViewListItems:[Int:CallForm] =  [
        0:CallForm(name: "Assigned User", type: 6),
        1:CallForm(name: "Contact", type: 6),
        2:CallForm(name: "Date", type: 5),
        3:CallForm(name: "Duration", type: 9),
        4:CallForm(name: "Comments", type: 8),
    ]
    
    static let daysOffViewListItems:[Int:DaysOffForm] =  [
        0:DaysOffForm(name: "Date", type: 5),
        1:DaysOffForm(name: "Employees", type: 6),
        2:DaysOffForm(name: "Comments", type: 8),
    ]
    
    static let projectViewListItems:[Int:ProjectForm] =  [
        0:ProjectForm(name: "Code", type: 1),
        1:ProjectForm(name: "Title", type: 1),
        2:ProjectForm(name: "Status", type: 3),
        3:ProjectForm(name: "Start Date", type: 5),
        4:ProjectForm(name: "Finish Date", type: 5),
        5:ProjectForm(name: "Contacts", type: 6),
        6:ProjectForm(name: "Tasks", type: 7),
    ]
    
    static let taskViewListItems:[Int:TaskForm] =  [
        0:TaskForm(name: "Code", type: 1),
        1:TaskForm(name: "Title", type: 1),
        2:TaskForm(name: "Status", type: 3),
        3:TaskForm(name: "Start Date", type: 5),
        4:TaskForm(name: "Finish Date", type: 5),
        5:TaskForm(name: "Assignments", type: 6),
        6:TaskForm(name: "Comments", type: 8)

    ]
    
    static let goalSettingsViewListItems:[Int:GoalSettingsForm] =  [
        0:GoalSettingsForm(name: "Title", type: 1),
        1:GoalSettingsForm(name: "Project", type: 10),
        2:GoalSettingsForm(name: "Type", type: 11),
        3:GoalSettingsForm(name: "Initial Metric", type: 9),
        4:GoalSettingsForm(name: "Current Metric", type: 9),
        5:GoalSettingsForm(name: "Start Date", type: 5),
        6:GoalSettingsForm(name: "Finish Date", type: 5),
        7:GoalSettingsForm(name: "Complete", type: 2),
    ]
   
    static let evaluattionViewListItems:[Int:EvaluationForm] =  [
        0:EvaluationForm(name: "Title", type: 1),
        1:EvaluationForm(name: "Employee", type: 6),
        2:EvaluationForm(name: "Start Date", type: 5),
        3:EvaluationForm(name: "Finish Date", type: 5),
        4:EvaluationForm(name: "Date of Evaluation", type: 5),
        5:EvaluationForm(name: "Performance", type: 12),
        6:EvaluationForm(name: "Comments", type: 8),

    ]
    
    static let types:[Int:String] = [
        0:"Customer",
        1:"Supplier",
        2:"Εmployee"
    ]
    
    static let projectStatus:[Int:String] = [
        0:"Open",
        1:"Pending",
        2:"Completed",
        3:"Cancelled"
    ]
    
    static let goalSettingsTypes:[Int:String] = [
        0:"Number",
        1:"Percent (%)"
    ]
    
    static let evaluationCategories:[Int:String] = [
        0:"Works to Full Potential",
        1:"Quality of Work",
        2:"Work Consistency",
        3:"Communication",
        4:"Independent Work",
        5:"Takes Initiative",
        6:"Group Work",
        7:"Productivity",
        8:"Creativity",
        9:"Honesty",
        10:"Integrity",
        11:"Coworker Relations",
        12:"Client Relations",
        13:"Technical Skills",
        14:"Dependability",
        15:"Punctuality",
        16:"Attendance"
    ]

    static let projectStatusColors:[Int:Color] = [
        0:Color.yellow.opacity(0.6),
        1:Color.orange.opacity(0.6),
        2:Color.green.opacity(0.6),
        3:Color.red.opacity(0.6)
    ]
    
    static let calendarBackgroundColorS:[String:AppColors] = [
        "orangeOpacity03":.orangeOpacity03,
        "greenOpacity03":.greenOpacity03,
        "black":.black,
        "gray":.gray,
        "clear":.clear
    ]
    
    static let projectStatusColorsV2:[Int:AppColors] = [
        0:.blueOpacity03,
        1:.orangeOpacity03,
        2:.greenOpacity03,
        3:.redOpacity03
    ]
    
    static let paymentCardListItems:[Int:PaymentForm] =  [
        0:PaymentForm(name: "Title", type: 1),
        1:PaymentForm(name: "Contacts", type: 6),
        2:PaymentForm(name: "Comments", type: 8),
        3:PaymentForm(name: "Date", type: 5),
        4:PaymentForm(name: "Price (\(currency))", type: 9),
    ]
    
    static let paymentCardListItemsWithoutCustomers:[Int:PaymentForm] =  [
        0:PaymentForm(name: "Title", type: 1),
        1:PaymentForm(name: "Comments", type: 8),
        2:PaymentForm(name: "Date", type: 5),
        3:PaymentForm(name: "Price (\(currency))", type: 9),
    ]
    
    static let dynamicFormsFieldsTypes:[DynamicFormsFieldsTypes] =  [
        DynamicFormsFieldsTypes(kind:1,name:"Text"),
        DynamicFormsFieldsTypes(kind:4,name:"Phone"),
        DynamicFormsFieldsTypes(kind:8,name:"Textarea"),
        DynamicFormsFieldsTypes(kind:2,name:"Toggle"),
        DynamicFormsFieldsTypes(kind:5,name:"Date"),
        DynamicFormsFieldsTypes(kind:9,name:"Price"),
        DynamicFormsFieldsTypes(kind:3,name:"Countries"),
        DynamicFormsFieldsTypes(kind:6,name:"Contacts"),
        DynamicFormsFieldsTypes(kind:10,name:"Projects")
    ]
    
    static let dynamicFormsFieldsTypesImages:[Int:String] = [
        1:"textformat",
        4:"phone",
        8:"note.text",
        2:"switch.2",
        5:"calendar",
        9:"dollarsign",
        3:"globe.europe.africa.fill",
        6:"person.crop.circle",
        10:"pencil.slash"
    ]

    static let loginUrlApi = "YOUR_USER_LOGIN_URL_API"

    static let registerUrlApi = "YOUR_USER_REGISTER_URL_API"
    
    static let deleteUrlApi = "YOUR_USER_DELETE_URL_API"
    
    static let currency = "€"
    
    static let userFileManagereURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("userData")
    
    static let themeColorFileManagereURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("themeColor")
    
    static let activeMenuFileManagereURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("activeMenu")
    
    static let allReportsList:[String] = ["Employee Evaluations","Ecomomics"]
    
    static let filterEvaluationsValues = [0,1,2,3,4,5,6,7,8,9]
    
    static let sortEvaluations = [0:"Start Date Asc",1:"Start Date Desc",2:"Finish Date Asc",3:"Finish Date Desc",4:"Evaluation Asc",5:"Evaluation Desc"]
    
    static let sortMeetings = [0:"Date Asc",1:"Date Desc"]
    
    static let sortCalls = [0:"Date Asc",1:"Date Desc"]
    
    static let economicsKindFilter = [0:"All",1:"Incomes",2:"Expenses"]
    
    static let months = [1:"Jan",2:"Feb",3:"Mar",4:"Apr",5:"May",6:"Jun",7:"Jul",8:"Aug",9:"Sep",10:"Oct",11:"Nov",12:"Dec"]
    
    static let startYear = 1970
    
    static let endYear = 2100
    
//    static let importMessage = ""
}
