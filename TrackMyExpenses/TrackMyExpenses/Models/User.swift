//
//  User.swift
//  TrackMyExpenses
//
//  Created by Austin Potts on 8/26/23.
//

import Foundation


class User: ObservableObject {
    var email: String
    var name: String
    var expenses: [Transaction]
    
    init(email: String, name: String, expenses: [Transaction]) {
        self.email = email
        self.name = name
        self.expenses = expenses
    }
    
}
