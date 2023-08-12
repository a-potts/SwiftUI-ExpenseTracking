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



    
    var body: some View {
        NavigationView {
            
            Form {
                Section(header: Text("Account")) {
                    TextField("Account Name", text: $account)
                }
                
                Section(header: Text("Amount")) {
                    TextField("Enter Amount", text: $amount)
                }
                
                Section(header: Text("Category")) {
                    TextField("Enter Category", text: $category)
                }
                
                Section(header: Text("Date")) {
                    TextField("Enter Date", text: $date)
                }
                
                Section(header: Text("Institution")) {
                    TextField("Enter Bank", text: $institution)
                }
                
                Section(header: Text("Merchant")) {
                    TextField("Enter Merchant", text: $merchant)
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
                
                

            }

        }
    }
    
    
    
    private func addExpense(){
        
        let expense: [String : Any] = [
            "account": account,
            "amount": amount,
            "category": category,
            "date": date,
            "institution": institution,
            "merchant": merchant,
            
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
