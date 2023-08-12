//
//  AddExpense.swift
//  TrackMyExpenses
//
//  Created by Austin Potts on 8/11/23.
//

import SwiftUI
import Firebase

struct AddExpense: View {
    
    //These states are used within this view only, apple suggests they must be private
    @State private var name: String = ""
    @State private var selectedCategory: Category = Category.bankFee
    @State private var description: String = ""
    @State private var ingredients: String = ""
    @State private var directions: String = ""
    
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {
        
        NavigationView {
            
            Form {
                //Binding Arguement is recognized by $
                Section(header: Text("Name")) {
                    TextField("Recipe Name", text: $name)
                }
                Section(header: Text("Category")) {
                    Picker("Category", selection: $selectedCategory) {
                        
                        //For each auto assigns tags per each item id, sometimes it doesnt work so add the tag modifier anyway
                        ForEach(Category.allCases) { category in
                            Text(category.rawValue)
                                .tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section(header: Text("Description")) {
                    TextEditor(text: $description)
                    
                }
                Section(header: Text("Ingredients")) {
                    TextEditor(text: $ingredients)
                    
                }
                Section(header: Text("Directions")) {
                    TextEditor(text: $directions)
                    
                }
                
            }
        
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        
                        dismiss()
                    } label: {
                        Label("Cancel", systemImage: "xmark")
                            .labelStyle(.iconOnly)
                    }
                    
                }
                
                
                ToolbarItem {
                    
                    //destination is the RecipeView whos recipe is the most recent of the list
                    
                    //Before I was using sort to compare the latest data entry by date, when connected to firebase this result prints correclty but returns incorrectly in the app. I created a work around below by creating an object on the view for the user to see temporarily
                    
                    
                    NavigationLink(destination: ContentView) {
                        
                        
                        Button {
                            //MARK: SAVE RECIPE
                            
                            //
                            //     saveRecipe()
                            
                            //isActive is so we know to only activate when done button is tapped - which is of type binding boolean
                            //  navigateToRecipe = true
                        } label: {
                            Label("Done", systemImage: "checkmark")
                                .labelStyle(.iconOnly)
                        }
                    }
                    .navigationBarBackButtonHidden(true)
                    .disabled(name.isEmpty)
                    
                
                    
                }
            })
            .navigationTitle("New Recipe")
            .navigationBarTitleDisplayMode(.inline)
        }
    
        .navigationViewStyle(.stack)
        
        
        }
}

struct AddExpense_Previews: PreviewProvider {
    static var previews: some View {
        AddExpense()
    }
}
