//
//  TransactionListViewModel.swift
//  TrackMyExpenses
//
//  Created by Austin Potts on 8/1/23.
//

import Foundation
import Combine
import Collections

//Type Alias
typealias TransactionGroup = OrderedDictionary<String, [Transaction]>
//String represent date , double equals the sum
typealias TransactionPrefixSum = [(String, Double)]

// Observable object is part of the combine framewrok which turns any object into  publisher & nottifes its subscribers to refresh their view
final class TransactionListViewModel: ObservableObject {
    
    //Responsible for sending notifgications to the subscribers when values are changed
    @Published var transaction: [Transaction] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        getTransactions()
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
        guard !transaction.isEmpty else {return []}
        
        let today = "02/17/2022".dateParse() // should be Date() FIX
        let dateInterval = Calendar.current.dateInterval(of: .month, for: today)!
        print("dateInterval", dateInterval)
        
        var sum: Double = 0
        var accumulatedSum = TransactionPrefixSum()
        
        for date in stride(from: dateInterval.start, through: today, by: 60 * 60 * 24) {
            let dailyExpenses = transaction.filter({ $0.dateParse == date && $0.isExpense })
            let dailyTotal = dailyExpenses.reduce(0) { $0 - $1.signedAmount }
            
            sum += dailyTotal
            sum = sum.roundedTo2Digits()
            accumulatedSum.append((date.formatted(), sum))
            print(date.formatted(), "daily total", dailyTotal, "sum", sum)
            
        }
        return accumulatedSum

    }
    
}
