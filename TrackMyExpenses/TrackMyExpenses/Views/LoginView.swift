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
    
    @StateObject var transactionListVM = TransactionListViewModel()

    
    @State private var name: String = ""
    @State private var password: String = ""
    //Using @State to update the views on a struct, accessing the binding properties
    @State private var wrongUsername = 0
    @State private var wrongPassword = 0
    @State private var showingLoginScreen = false
    
    
    var userVM: UserViewModel = UserViewModel()
    
    @State private var userIsLoggedIn: Bool = false
    @State private var registerButtonTapped: Bool = false
    
    @State private var viewTitle: String = "Login"
    @Environment(\.dismiss) var dismiss
    

    
    
    var body: some View {
        
        
        
        if userIsLoggedIn == true {
            
            //Becasue this view now becomes the ancestor of ViewModel, we need to add it to environment object
            ContentView()
                .environmentObject(transactionListVM)
            
            
        } else {
            content
        }
    }
    
    var content: some View {
        
        
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
                    
                    //If register button has not been tapped
                    if registerButtonTapped != true {
                        
                        
                        
                        Button("Login") {
                            print("tapped")
                            userVM.signOut()
                            
                            // Authenticate user
                            userVM.login(email: name, password: password)
                            Auth.auth().addStateDidChangeListener { auth, user in
                                // if there is a user, toggle the boolean true
                                if user != nil {
                                    print("User is not Nil \(user?.email)" ?? "Email")
                                    userIsLoggedIn.toggle()
                                    transactionListVM.getExpenses()
                                } else {
                                    print("Error Logging in")
                                }
                            }
                        }
                        //.foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background (Color.green)
                        .cornerRadius (10)
                        
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
                 
                    
               
                    

                } // end of Vstack
                
            }
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
        
    }
}
