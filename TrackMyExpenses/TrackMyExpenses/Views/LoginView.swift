//
//  LoginView.swift
//  TrackMyExpenses
//
//  Created by Austin Potts on 8/26/23.
//

import SwiftUI
import Combine
import FirebaseAnalyticsSwift
import Firebase

struct LoginView: View {
    
    @EnvironmentObject var transactionListVM: TransactionListViewModel
    @EnvironmentObject var session: UserViewModel
    
    @State private var name: String = ""
    @State private var password: String = ""
    //Using @State to update the views on a struct, accessing the binding properties
    @State private var wrongUsername = 0
    @State private var wrongPassword = 0
    
    
    var userVM: UserViewModel = UserViewModel()
    
    @State private var userIsLoggedIn: Bool = false
    @State private var registerButtonTapped: Bool = false
    
    
    @State private var viewTitle: String = "Login"
   
    @State private var showingSheet = false
    
    @State private var loginButtonTapped: Bool = false

    
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color.green
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)
                
                VStack {
                    Text(viewTitle)
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    TextField("Username", text: $name)
                        .padding()
                        .frame(width: 300, height: 50) .background (Color.black.opacity (0.05))
                        .cornerRadius(10)
                       // .border(.red, width: CGFloat(wrongUsername))
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50) .background (Color.black.opacity (0.05))
                        .cornerRadius(10)
                        //.border(.red, width: CGFloat(wrongPassword))
                    
                    
                    //MARK: Login
                    
                    if registerButtonTapped != true {
                        
                        
                        
                        Button("Login") {
                            
                            print("tapped")
                            userVM.signOut()
                            
                            
                          
                            // Authenticate user
                            userVM.login(email: name, password: password)
                            Auth.auth().addStateDidChangeListener { auth, user in
                                // if there is a user, toggle the boolean true
                                if user != nil {
                                    print("User is not Nil \(user?.email ?? "Email")")
                                    userIsLoggedIn.toggle()
                                    
                                    transactionListVM.getExpenses()
                                    if transactionListVM.transaction.isEmpty {
                                        
                                        print("LOGIN TRANS COUNT \(transactionListVM.transaction.count)")
                                        //transactionListVM.transaction.removeAll()

                                       // transactionListVM.getExpenses()
                                        showingSheet.toggle()
                                       return
                                        
                                    } else {
                                       // transactionListVM.getExpenses()
                                        print("SHEET TOGGLE COUNT IS MORE THAN 0")
                                       // transactionListVM.transaction.removeAll()
                                        showingSheet.toggle()
                                    }
                                    
                                } else {
                                    //print("Error Logging in")
                                }
                            }
                            
                            
                        }
                        .frame(width: 300, height: 50)
                        .background (Color.green)
                        .cornerRadius (10)
                        
                        
                        .fullScreenCover(isPresented: $showingSheet, content: {
                            
                            ContentView()
                                .environmentObject(self.transactionListVM)
                        })

                        
                        Button("No account?") {
                            print("tapped")
                            
                            //Toggle a boolean that lets the view know to change i.e register tapped = true
                            registerButtonTapped.toggle()
                            //If true, replace login button + logic with register button + logic
                            
                         
                            // Authenticate user
                            userVM.registerVM(email: name, password: password)
                            transactionListVM.getExpenses()
                            
                            
                        }
                        //.foregroundColor(.white)
                        
                    } else {
                        //MARK: Register
                        Button("Register") {
                            
                            self.viewTitle = "Register"
                            
                            print("tapped")
                            
                            // Authenticate user
                            userVM.signOut()
                            userVM.registerVM(email: name, password: password)
                            registerButtonTapped.toggle()
                            Auth.auth().addStateDidChangeListener { auth, user in
                                // if there is a user, toggle the boolean true
                                if user != nil {
                                    print(user?.email ?? "Error Logging In")
                                    userIsLoggedIn.toggle()
                                } else {
                                    print("Error Register")
                                }
                            }
                        }
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background (Color.blue)
                        .cornerRadius (10)
                        
                    }
                 
                }
                
            }
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static let transactionListVM: TransactionListViewModel = {
     let transactionListVM = TransactionListViewModel()
     transactionListVM.transaction = transactionListPreviewData
     return transactionListVM
 }()
    
    static var previews: some View {
        LoginView()
            .environmentObject(transactionListVM)
        
        ContentView()
            .environmentObject(transactionListVM)
        
    }
}
