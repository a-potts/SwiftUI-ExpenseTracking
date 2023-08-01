//
//  TransactionListViewModel.swift
//  TrackMyExpenses
//
//  Created by Austin Potts on 8/1/23.
//

import Foundation
import Combine

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
    
}
