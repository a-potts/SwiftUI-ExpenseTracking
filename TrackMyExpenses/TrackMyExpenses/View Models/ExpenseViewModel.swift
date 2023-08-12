//
//  ExpenseViewModel.swift
//  TrackMyExpenses
//
//  Created by Austin Potts on 8/11/23.
//

import Foundation
import FirebaseFirestore


class AddExpenseViewModel: ObservableObject {
    
    @Published private (set) var expense: [Transaction] = []
    
    
    init() {
        getExpenses()
    }
    
    
    
    
    //MARK: Fetch From Database
    func getExpenses(){
        // create db instance
        
        let db = Firestore.firestore()
        
        // create document reference using above with dot syntax
        
        let docRef = db.collection("Expenses")
        
        //use above url to iterate through the snapshot
        
        docRef.getDocuments { snapshot, error in
            guard error == nil else {
                print (error!.localizedDescription)
                return
                
            }
            
            if let snapshot = snapshot {
                //Iterate through the snapshot values & append each value to the property array
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let account = data["account"] as? String ?? ""
                    let amount = data["amount"] as? Double ?? 0.0
                    let category = data["category"] as? String ?? ""
                    let categoryId = data[""] as? Int ?? 1
                    let date = data["date"] as? String ?? ""
                    let institution = data["institution"] as? String ?? ""
                    let merchant = data["merchant"] as? String ?? ""
                    let id = data[""] as? Int ?? 1
                    let type = data["type"] as? String ?? ""
                    let isPending = data[""] as? Bool ?? false
                    let isTransfer = data[""] as? Bool ?? false
                    let isExpense = data[""] as? Bool ?? true
                    let isEdited = data[""] as? Bool ?? false


                    
                    
                    
                    let newExpense = Transaction(id: id, date: date, institution: institution, account: account, merchant: merchant, amount: amount, type: type, categoryId: categoryId, category: category, isPending: isPending, isTransfer: isTransfer, isExpense: isExpense, isEdited: isEdited)
                    self.expense.append(newExpense)
                    
                }
            }
            
        }
        
    }
    
   
    
}
