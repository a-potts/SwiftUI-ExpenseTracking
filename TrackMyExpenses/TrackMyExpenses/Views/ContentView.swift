//
//  ContentView.swift
//  TrackMyExpenses
//
//  Created by Austin Potts on 8/1/23.
//

import SwiftUI
import SwiftUICharts



struct ContentView: View {
    @EnvironmentObject private var transactionListsVM: TransactionListViewModel
    
    @EnvironmentObject var userVM: UserViewModel
    
    @State var lineChart = LineChart()
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss

    @State private var showLogin = false
    
    
   
    
    var body: some View {
        
        
        NavigationView {
            ScrollView {
                VStackLayout(alignment: .leading, spacing: 24){
                    
                    Divider()
                    
                    //MARK: Title
                    Text("Total Expenses for \(Date().formatted(Date.FormatStyle().year()))")
                        .font(.title2)
                        .bold()
                        
                       
                        //MARK: Chart
                    
                        
                        let data = transactionListsVM.accumulateTransaction()
                        if !data.isEmpty {
                            let totalExpenses = data.last?.1 ?? 0
                            CardView {
                                VStack(alignment: .leading) {
                                    ChartLabel(totalExpenses.formatted(.currency(code: "USD")), type: .title, format: "$%.02f")
                                    
                                    lineChart
                                }
                                    .background(Color.systemBackground)

                                    
                            }
                            //Modifiers
                            
                            .data(data)
                            
                            .chartStyle(ChartStyle(backgroundColor: Color.systemBackground, foregroundColor: ColorGradient(Color.red.opacity(0.4), Color.red)))
                        
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
                //MARK: Logout Icon
                ToolbarItem(placement: .navigationBarLeading) {
                    
                
                  
                //MARK: SIGN OUT Button
                   
                        
                    Button(action:  {
                        print("logout pressed")
                        userVM.signOut()
                      //  transactionListsVM.transaction.removeAll() // Causes duplicates
                        
                        dismiss()
                        
                        
                    }) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(Color.red, .primary)
                            Text("Sign Out")
                                .bold()
                                .foregroundColor(.red)
                        }
                   
                    
                }
                
                
                //MARK: ADD Button for Navigation to Form
                
                ToolbarItem {
                    
                    NavigationLink(destination: AddNewExpense()){
                        
                        Text("Add")
                            .foregroundColor(Color.icon)
                            .bold()
                        Image(systemName: "square.and.pencil")
                        // modifier
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color.icon, .primary)
                    }
                }
            }
            
        }
        //modifier
        .navigationViewStyle(.stack)
        .accentColor(.primary)
        
        
       
        
    } // Var End
    
    
} //Class End

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
