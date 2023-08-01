//
//  TransactionModel.swift
//  TrackMyExpenses
//
//  Created by Austin Potts on 8/1/23.
//

import Foundation

struct Transaction: Identifiable {
    
    let id: Int
    let date: String
    let institution: String
    let account: String
    var merchant: String
    let amount: Double
    let type: TransactionType.RawValue
    var categoryId: Int
    var category: String
    let isPending: Bool
    var isTransfer: Bool
    var isExpense: Bool
    var isEdited: Bool
    
    //Computed property that will be used in the transaction row 
    var dateParse: Date {
        date.dateParse()
    }
    
    var signedAmount: Double {
        return type == TransactionType.credit.rawValue ? amount : -amount
    }
    
}

enum TransactionType: String {
    case debit = "debit"
    case credit = "credit"
}
