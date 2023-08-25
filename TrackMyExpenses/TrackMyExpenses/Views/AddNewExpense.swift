//
//  AddNewExpense.swift
//  TrackMyExpenses
//
//  Created by Austin Potts on 8/11/23.
//

import SwiftUI
import FirebaseFirestore

struct AddNewExpense: View {
    
    @State private var account: String = ""
    @State private var amount: String = ""
    @State private var category: String = ""
    @State private var date: String = ""
    @State private var institution: String = ""
    @State private var merchant: String = ""
    @State private var type: String = ""
    @State private var selectedCategory = Category.autoAndTransport

    
    
    //@state is designed to be shared
    //@state should be used when creating values, if youre just reading it or modifyng it use @observed object
    @EnvironmentObject private var transaction: TransactionListViewModel

    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            
            
            
            Form {
                
                Section(header: Text("Account")) {
                    TextField("Account Name", text: $account)
                }
                
                Section(header: Text("Amount")) {
                    TextField("Enter Amount", text: $amount)
                }
                
                //MARK: Make this a Menu selection
                Section(header: Text("Category")) {
                    Picker("Category", selection: $selectedCategory) {
                        
                        //For each auto assigns tags per each item id, sometimes it doesnt work so add the tag modifier anyway
                        ForEach(Category.all, id: \.self) { category in
                            Text(category.name)
                                
                        }
                    }
                    .pickerStyle(.menu)
                    
                }
                
                Section(header: Text("Institution")) {
                    TextField("Enter Bank", text: $institution)
                }
                
                Section(header: Text("Merchant")) {
                    TextField("Enter Merchant", text: $merchant)
                }
                
                Section(header: Text("Type")) {
                    TextField("Enter Debit or Credit", text: $type)
                }
                
                Button {
                    addExpense()
                    
                    
                    
                    
                    let _ = transaction.accumulateTransaction()
                    
                    
                    
                    dismiss()
                } label: {
                    Text("Enter New Expense")
                        .padding()
                        .foregroundColor(.white)
                        .bold()
                }
                .background(.green)
                .cornerRadius(5)
                .navigationTitle("Add New Expense")
                
                
                
            }
            
            
        }
    }
    
    
    
    private func addExpense(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let date = formatter.string(from: Date.now)
        
       
        let count = self.transaction.transaction.count
        print("Count Here: \(count)")
        let totalNewId = count + 1
        
        var catInt = 0
        
//        for cat in Category.all {
//            if cat.name == category {
//                catInt = cat.id
//            }
//        }
        
        
        
        let expense: [String : Any] = [
            "account": account,
            "amount": Double(amount) as Any,
            "category": selectedCategory.name,      // This must be a string for Firestore
            "categoryId": selectedCategory.id as Any,  // This must be the Int which identifies the Icon Category
            "date": date,
            "id": totalNewId as Any,
            "institution": institution,
            "merchant": merchant,
            "type" : type,
            
            //MARK: Fix these later by adding menu selections above for the values below
            "isEdited" : false,
            "isExpense" : true,
            "isPending" : false,
            "isTransfer" : false
            
            ]
        
                  
        let db = Firestore.firestore().collection("Transactions")
     
        db.addDocument(data: expense)
        
        transaction.transaction.append(Transaction(expenseId: self.transaction.transaction.count + 1, date: date, institution: institution, account: account, merchant: merchant, amount: Double(amount)!, type: "Debit", categoryId: selectedCategory.id, category: selectedCategory.name, isPending: false, isTransfer: false, isExpense: true, isEdited: false))
        
        
    }
    
    
    
}

struct AddNewExpense_Previews: PreviewProvider {
    
    //This is a trick to force data to the preview model
    //Need to add this since we declared a insatce of the property above, it will have no value when the process reaches it so we must set one
    //Declare a lazy static constant
    static let transactionListVM: TransactionListViewModel = {
        //inside the closure create an instance of TLVM
     let transactionListVM = TransactionListViewModel()
     transactionListVM.transaction = transactionListPreviewData
     return transactionListVM
        
        //init static constant
        
 }()
    
    static var previews: some View {
        Group{
            AddNewExpense()
            
                .preferredColorScheme(.dark)
        }
        .environmentObject(transactionListVM)
        
    }
        
}
