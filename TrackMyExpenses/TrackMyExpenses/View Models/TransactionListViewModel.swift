//
//  TransactionListViewModel.swift
//  TrackMyExpenses
//
//  Created by Austin Potts on 8/1/23.
//

import Foundation
import Combine
import Collections
import FirebaseFirestore
import FirebaseAuth

public extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}


//Type Alias
typealias TransactionGroup = OrderedDictionary<String, [Transaction]>
//String represent date , double equals the sum
typealias TransactionPrefixSum = [(String, Double)]

// Observable object is part of the combine framewrok which turns any object into  publisher & nottifes its subscribers to refresh their view
final class TransactionListViewModel: ObservableObject {
    
    //Responsible for sending notifgications to the subscribers when values are changed
    // Please publish announcements when this value changes
    @Published var transaction: [Transaction] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        //MARK: I commented this out because it causes a double fetch, bypassing the UUID depedency on the object causing fetched data for any user instead of specific one
    }
    
    
    //MARK: Fetch From Database
    
    //ERROR: Upon signing out the login button does not fire this off
    func getExpenses() {
        
      
            
            guard let uid = Auth.auth().currentUser?.uid else {
                print("ERROR NO UUID")
                return
            }
            
        
            
            // create db instance
            
            let db = Firestore.firestore()
            
            // create document reference using above with dot syntax
            
            let docRef = db.collection("users").document(uid).collection("Transactions")
            
            //use above url to iterate through the snapshot
            
            docRef.getDocuments { snapshot, error in
                guard error == nil else {
                    print (error!.localizedDescription)
                    return
                    
                }
                
                //Ensure there are no current transactions in the array before Loop iterates firebase snapshot to add to it
                self.transaction.removeAll()
                print("TRANSACTION SHEET COUNT HERE: \(self.transaction.count)")
                
                if self.transaction.count > 0 {
                    print("TRANSACTION SHEET COUNT ZERO: \(self.transaction.count)")

                    return
                }

                if let snapshot = snapshot {
                    
                    //Iterate through the snapshot values & append each value to the property array
                    for document in snapshot.documents  {
                        
                        
                        
                        let data = document.data()
                        
                        let account = data["account"] as? String ?? ""
                        let amount = data["amount"] as? Double ?? 0.0
                        let category = data["category"] as? String ?? ""
                        let categoryId = data["categoryId"] as? Int ?? 1
                        let date = data["date"] as? String ?? ""
                        let institution = data["institution"] as? String ?? ""
                        let merchant = data["merchant"] as? String ?? ""
                        let expenseId = data[""] as? Int ?? 1
                        let type = data["type"] as? String ?? ""
                        let isPending = data[""] as? Bool ?? false
                        let isTransfer = data[""] as? Bool ?? false
                        let isExpense = data[""] as? Bool ?? false
                        let isEdited = data[""] as? Bool ?? false


                        
                        
                        
                        let newExpense = Transaction(expenseId: expenseId, date: date, institution: institution, account: account, merchant: merchant, amount: amount, type: type, categoryId: categoryId, category: category, isPending: isPending, isTransfer: isTransfer, isExpense: isExpense, isEdited: isEdited)
                        
                        
                        
                            self.transaction.append(newExpense)
                        
                        
                        

                        
                        
                    }
                    
                }
                
            }
        
        
    }
    
    
  
    
    func groupTransactionByMonth() -> TransactionGroup {
        guard !transaction.isEmpty else {return [:]}
        
        let groupTransaction = TransactionGroup(grouping: transaction) { $0.month }
        
        return groupTransaction
    }
    
    
    func accumulateTransaction() -> TransactionPrefixSum {
        print("Accumulate transactions")
        guard !transaction.isEmpty else {
            print("EMPTY - \(transaction.count)")
            return []
            
        }
       
        
        print("FULL - \(transaction.count)")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let newToday = formatter.string(from: Date.now)
        
        let today = newToday.dateParse()
        
        
//        //This for some reason works, but the newtoday below does not
        let oldToday = "07/31/2023"
        let oldTodayDate = formatter.date(from: oldToday)
        let oldestToday = oldToday.dateParse()
//
//
//        // "09/01/2023" doesnt work
//        let today = "\(Date())"
//        let newestToday = formatter.date(from: today)
//        newestToday.dateParse()
//        print("NEW TODAY \(newToday)")
        
        
        let dateInterval = Calendar.current.dateInterval(of: .month, for: oldestToday)! //of the month that includes today
        print("dateInterval", dateInterval)
        
        //single value
        var sum: Double = 0
        //set of values
        var accumulatedSum = TransactionPrefixSum()
        
        //Stride throuhg unwanted properties to get full day with int value below
        for date in stride(from: dateInterval.start, through: today, by: 60 * 60 * 24) {
            
            
            let dailyExpenses = transaction.filter({ $0.dateParse == date })
            
          //  print("Daily Expense \(dailyExpenses)")
           // print("Transaction Expense \(transaction)")

            let dailyTotal = dailyExpenses.reduce(0) { $0 + $1.signedAmount } //sum using reduce of those filtered amounts
            
           // print("Daily Total \(dailyTotal)")

            sum += dailyTotal
            sum = sum.roundedTo2Digits()
            accumulatedSum.append((date.formatted(), sum))
           // print("ACCUMULATED SUM \(accumulatedSum)")
            
         //   print(date.formatted(), "daily total", dailyTotal, "sum", sum)
            
        }
        
        
        return accumulatedSum

    }
    
}
