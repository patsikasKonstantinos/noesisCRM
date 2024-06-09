import Foundation
import RealmSwift
import Combine

class PaymentViewModel: ObservableObject {
    
    //MARK: Published Properties
    @Published var contactId:ObjectId?
    @Published var paymentId:ObjectId?
    @Published var selectedPayment: Payments?
    @Published var selectedContacts: [Contacts] = []
    @Published var allPaymentsList: [Payments] = []
    @Published var inputTextStringsController: [String] = ["", "", "", "", ""]
    @Published var paymentsViewItems =  Variables.paymentCardListItems
    @Published var showingAlert = false
    @Published var alertMessage = ""
    @Published var filledTitle = true
    @Published var filledPrice = true
    @Published var paymentDate = Date()
    @Published var paymentPrice = ""
    @Published var fromNavigation = false
    @Published var addNewEntry = false
    
    //MARK: let Properties
    private let dismissView = PassthroughSubject<Void, Never>()
    private let paymentObj = PaymentsFunctionality()
    private let projectsObj = ProjectsFunctionality()
    private let contactsObj = ContactsFunctionality()
    private var firstLoad: Bool = true
    
    //MARK: var Properties
    var newPayment: Bool
    var isIncome: Bool
    var isExpenses: Bool
    var hiddenContacts:Bool
 
    var dismissRequest: AnyPublisher<Void, Never> {
        dismissView.eraseToAnyPublisher()
    }

    lazy var selectContactsViewModel: SelectContactsViewModel = {
           return SelectContactsViewModel(multiple: true, contactType: 3,selected: selectedContacts)
    }()
    
    //MARK: Initialization
    init(selectedPayment: Payments?, contactId:ObjectId?, newPayment: Bool, isIncome: Bool, isExpenses: Bool,hiddenContacts:Bool){
        self.selectedPayment = selectedPayment
        self.contactId = contactId
        self.newPayment = newPayment
        self.isIncome = isIncome
        self.isExpenses = isExpenses
        self.hiddenContacts = hiddenContacts
        if let payment = selectedPayment {
            // Initialize selectedContacts if it's an existing payment
            selectContactsViewModel.selected = projectsObj.convertCustomersListToArray(payment.customers)
        }
    }
    
    //MARK: Functions
    func resetForm(){
        if(newPayment){
            filledTitle = true
            showingAlert = false
            inputTextStringsController = ["", "", "", "", ""]
            paymentDate = Date()
            filledPrice = true
            paymentPrice = ""
            
            if !hiddenContacts {
                selectedContacts = []
                selectContactsViewModel.selected = []
            }
        }
    }
    
    func setup(){
        if(!newPayment && !fromNavigation){
            paymentDate = selectedPayment!.date
            paymentPrice = "\(selectedPayment!.price)"
            inputTextStringsController = [selectedPayment!.title,"","\(selectedPayment!.comments)","\(selectedPayment!.date)","\(selectedPayment!.price)"]
        }
        if contactId != nil {
            selectContactsViewModel.selected = contactsObj.findContactsArrayFormat(contactId!)
        }
    }


    func savePayment(title: String, comments: String, paymentDate: Date, paymentPrice: String) {
        if title.isEmpty{
            filledTitle = false
            alertMessage = "Please fill out all required fields"
            showingAlert = true
        }
        else{
            
 
            if let paymentNowPrice = Float(paymentPrice) {
                showingAlert = false
                let currPaymentDataObj = Payments(
                    title: title,
                    customers:projectsObj.convertCustomersArrayToList(selectContactsViewModel.selected),
                    comments: comments,
                    date: paymentDate,
                    isIncome: isIncome,
                    isExpenses: isExpenses,
                    price: paymentNowPrice,
                    projects: projectsObj.convertProjectsArrayToList([])
                )

                allPaymentsList.removeAll { $0.isInvalidated }
 
                if(newPayment){
                  //If is not from Contacts View
                  if !hiddenContacts {
                      paymentObj.createNewPayment(currPaymentDataObj,false)
                  }
                  allPaymentsList.append(currPaymentDataObj)
 
                    //UPDATE ID TO SAVED PAYMENTS ID
                  //allPaymentsList[allPaymentsList.count-1].id = allPayments[allPayments.count-1].id
                }
                else{
                    paymentId = selectedPayment!.id
                    if !hiddenContacts {
                        paymentObj.savePayments(currPaymentDataObj, paymentId!)
                    }
                    //FOR CONTACT VIEW , ECONOMICS LIST
                    for i in 0..<allPaymentsList.count{
                        if allPaymentsList[i].id == paymentId! {
                            allPaymentsList[i] = currPaymentDataObj
                        }
                    }
                }
                
                dismissView.send()
            } else{
                alertMessage = "Please fill price field"
                filledPrice = false
                showingAlert = true
            }
        }
 
        allPaymentsList.sort(by: { $0.date > $1.date })
     }
}
