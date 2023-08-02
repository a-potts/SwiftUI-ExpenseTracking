//
//  ContentView.swift
//  TrackMyExpenses
//
//  Created by Austin Potts on 8/1/23.
//

import SwiftUI
import SwiftUICharts

struct ContentView: View {
    @EnvironmentObject var transactionListsVM: TransactionListViewModel
    //var demoData: [Double] = [8,2,4,5,7,9,12]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStackLayout(alignment: .leading, spacing: 24){
                    //MARK: Title
                    Text("Overview")
                        .font(.title2)
                        .bold()
                    
                    //MARK: Chart
                    let data = transactionListsVM.accumulateTransaction()
                    if !data.isEmpty {
                        let totalExpenses = data.last?.1 ?? 0
                        CardView {
                            VStack(alignment: .leading) {
                                ChartLabel(totalExpenses.formatted(.currency(code: "USD")), type: .title, format: "$%.02f")
                                
                                LineChart()
                            }
                                .background(Color.systemBackground)

                                
                        }
                        //Modifiers
                        .data(data)
                        .chartStyle(ChartStyle(backgroundColor: Color.systemBackground, foregroundColor: ColorGradient(Color.icon.opacity(0.4), Color.icon)))
                    
                    .frame(height: 300)
                    }
                 
                    
                    //MARK: Transaction List
                    RecentTransactionList()
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            //modifier for ScrollView
            .background(Color.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                //MARK: Notiifcation Icon
                ToolbarItem {
                    Image(systemName: "bell.badge")
                        // modifier
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(Color.icon, .primary)
                }
            }
        }
        //modifier
        .navigationViewStyle(.stack)
        .accentColor(.primary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static let transactionListVM: TransactionListViewModel = {
     let transactionListVM = TransactionListViewModel()
     transactionListVM.transaction = transactionListPreviewData
     return transactionListVM
 }()
    
    static var previews: some View {
        Group{
            ContentView()
            ContentView()
                .preferredColorScheme(.dark)
        }
        .environmentObject(transactionListVM)
    }
}
