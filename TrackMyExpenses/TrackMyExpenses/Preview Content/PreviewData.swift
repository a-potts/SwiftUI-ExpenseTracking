//
//  PreviewData.swift
//  TrackMyExpenses
//
//  Created by Austin Potts on 8/1/23.
//

import Foundation

var transactionPreviewData = Transaction(expenseId: 1, date: "1/24/2023", institution: "Chase", account: "AxeEvo LLC", merchant: "Apple", amount: 11.49, type: "debit", categoryId: 801, category: "Software", isPending: false, isTransfer: false, isExpense: true, isEdited: false)

var transactionListPreviewData = [Transaction](repeating: transactionPreviewData, count: 10)
