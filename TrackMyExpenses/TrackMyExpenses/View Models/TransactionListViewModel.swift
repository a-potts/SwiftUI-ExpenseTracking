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
        getExpenses()
    }
    
    
    //MARK: Fetch From Database
    func getExpenses(){
        // create db instance
        
        let db = Firestore.firestore()
        
        // create document reference using above with dot syntax
        
        let docRef = db.collection("Transactions")
        
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
    
    
    func getTransactions(){
        
        guard let url = URL(string: "https://designcode.io/data/transactions.json") else {
            print("Invalid URL")
            return
        }
        
        //Data task publisher is from Combine
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    //Dump is similar to print, good for large objects
                    dump(response)
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [Transaction].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error Fetching Transactions", error.localizedDescription)
                case .finished:
                    print("Finished Fetching Transactions")
                }
                
            } receiveValue: { [weak self] result in
                self?.transaction = result
                dump(self?.transaction)
            }
            .store(in: &cancellables)
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
        
        let today = newToday.dateParse() // should be Date() FIX
        let dateInterval = Calendar.current.dateInterval(of: .month, for: today)!
        print("dateInterval", dateInterval)
        
        //single value
        var sum: Double = 0
        //set of values
        var accumulatedSum = TransactionPrefixSum()
        
        for date in stride(from: dateInterval.start, through: today, by: 60 * 60 * 24) {
            
            
            let dailyExpenses = transaction.filter({ $0.dateParse == date })
            print("Daily Expense \(dailyExpenses)")
            print("Transaction Expense \(transaction)")

            let dailyTotal = dailyExpenses.reduce(0) { $0 - $1.signedAmount }
            
            print("Daily Total \(dailyTotal)")

            sum += dailyTotal
            sum = sum.roundedTo2Digits()
            accumulatedSum.append((date.formatted(), sum))
            
            //MARK: Error - daily total & sum are 0
            
            print(date.formatted(), "daily total", dailyTotal, "sum", sum)
            
        }
        return accumulatedSum

    }
    
}
