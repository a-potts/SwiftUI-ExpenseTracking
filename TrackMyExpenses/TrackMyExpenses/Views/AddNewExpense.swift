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
                    TextField("Enter Category", text: $category)
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
        
        let array = TransactionListViewModel()
        var count = array.transaction.count
        
        
        
        let expense: [String : Any] = [
            "account": account,
            "amount": Double(amount) as Any,
            "category": category,
            "categoryId": Int("1") as Any,
            "date": date,
            "id": count += 1,
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
        
    }
    
    
}

struct AddNewExpense_Previews: PreviewProvider {
    static var previews: some View {
        AddNewExpense()
    }
}
