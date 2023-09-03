//
//  UserViewModel.swift
//  TrackMyExpenses
//
//  Created by Austin Potts on 8/26/23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore
import Combine
import SwiftUI



class UserViewModel: ObservableObject {
    
//    var handle: AuthStateDidChangeListenerHandle?
//    var didChange = PassthroughSubject<UserViewModel, Never>()
//    var session: User? { didSet { self.didChange.send(self) }}
//    
//
//    func listen () {
//        // monitor authentication changes using firebase
//        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
//            if let user = user {
//                // if we have a user, create a new user model
//                print("Got user: \(user)")
//                self.session = User(email: user.email ?? "", name: user.email ?? "", expenses: [Transaction]())
//            } else {
//                // if we don't have a user, set our session to nil
//                self.session = nil
//            }
//        }
//    }
//    
//    func unbind () {
//        if let handle = handle {
//          Auth.auth().removeStateDidChangeListener(handle)
//        }
//      }
    
    
    @EnvironmentObject var transactionListsVM: TransactionListViewModel

    
    func registerVM(email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password)
        
        guard let uuid = Auth.auth().currentUser?.uid else {
            return
        }
        
        
        
        let userData = ["email": email, "uuid": uuid]
        
        Firestore.firestore().collection("users").document(uuid).setData(userData) { error in
            if let error = error {
                print(error)
                return
            }
            print("SUCCESS!! USERVM")
        }
    }
    
   
    
    func login(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password)
        
        
        
        
            
            
        
     //   listen()
    }

    func signOut() {
        do {
          try Auth.auth().signOut()
            
         //   unbind()
            
            print("SIGNED OUT")
        }
        catch {
          print("Error Signing Out \(error)")
        }
      }
    
   
    
    
  
}
