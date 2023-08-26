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
    
    @State private var name: String = ""
    @State private var password: String = ""
    
    @State private var userIsLoggedIn: Bool = false
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
