//
//  TrackMyExpensesApp.swift
//  TrackMyExpenses
//
//  Created by Austin Potts on 8/1/23.
//

import SwiftUI
import Firebase

@main
struct TrackMyExpensesApp: App {
    
    init(){
        FirebaseApp.configure()
        
    }
    
    
    //Wrap it in state object so it can follow the lifecycle of the app
    @StateObject var transactionListVM = TransactionListViewModel()
    @StateObject var userVM = UserViewModel()
    
    
    var body: some Scene {
        WindowGroup {
            
            LoginView()
                  .environmentObject(userVM)
            
//            ContentView()
//                .environmentObject(transactionListVM)
        }
    }
}
