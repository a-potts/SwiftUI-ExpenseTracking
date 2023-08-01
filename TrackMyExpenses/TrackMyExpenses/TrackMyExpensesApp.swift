//
//  TrackMyExpensesApp.swift
//  TrackMyExpenses
//
//  Created by Austin Potts on 8/1/23.
//

import SwiftUI

@main
struct TrackMyExpensesApp: App {
    
    //Wrap it in state object so it can follow the lifecycle of the app
    @StateObject var transactionListVM = TransactionListViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(transactionListVM)
        }
    }
}
