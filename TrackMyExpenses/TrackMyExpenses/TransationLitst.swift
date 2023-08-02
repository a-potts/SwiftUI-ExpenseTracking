//
//  TransationLitst.swift
//  TrackMyExpenses
//
//  Created by Austin Potts on 8/2/23.
//

import SwiftUI

struct TransationLitst: View {
    
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    
    
    var body: some View {
        VStack {
            List {
                //MARK: Transactions Group
                ForEach(Array(transactionListVM.groupTransactionByMonth()), id: \.key) {month, transaction in
                    Section {
                        //MARK: Transaction List
                        ForEach(transaction) { transaction in
                            TransactionRow(transaction: transaction)
                        }
                    } header: {
                        //MARK: Transaction Month
                        Text(month)
                    }
                    .listSectionSeparator(.hidden)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TransationLitst_Previews: PreviewProvider {
    static let transactionListVM: TransactionListViewModel = {
     let transactionListVM = TransactionListViewModel()
     transactionListVM.transaction = transactionListPreviewData
     return transactionListVM
 }()
    
    static var previews: some View {
        Group {
            //Embed in Navigation view
            NavigationView {
                TransationLitst()
            }
            NavigationView {
                TransationLitst()
                    .preferredColorScheme(.dark)
            }
        }
        .environmentObject(transactionListVM)

    }
}
