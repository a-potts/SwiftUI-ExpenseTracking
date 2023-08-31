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


class UserViewModel: ObservableObject {
    
   
    
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
    }

    func signOut() {
        do {
          try Auth.auth().signOut()
        }
        catch {
          print(error)
        }
      }
    
   
    
    
  
}
