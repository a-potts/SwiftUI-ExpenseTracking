//
//  ContentView.swift
//  TrackMyExpenses
//
//  Created by Austin Potts on 8/1/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                
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
                }
            }
        }
        //modifier
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
