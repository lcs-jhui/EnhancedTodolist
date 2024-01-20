//
//  TodoListView.swift
//  EnhancedTodolist
//
//  Created by Justin Hui on 20/1/2024.
//

import SwiftUI

struct TodoListView: View {
    
    // MARK: Stored properties
    
    //The search term the user provides
    @State var searchText = ""
    
    // The item currently being created
    @State private var newItemDetails = ""
    
    // Our list of items to complete
    @State private var items: [TodoItem] = []
    
    // MARK: Computed properties
    
    //filtering the array of items
    var filteredItems: [TodoItem] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.details.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        
        NavigationStack {
            VStack {
                
                HStack {
                    
                    TextField("Enter a to-do item", text: $newItemDetails)
                    
                    Button("Add") {
                        addItem()
                    }

                }
                .padding(20)
                
                if items.isEmpty {
                    
                    ContentUnavailableView(label: {
                        Label(
                            "Nothing to do",
                            systemImage: "powersleep"
                        )
                        .foregroundStyle(.green)
                    }, description: {
                        Text("To-do items will appear here once you add some.")
                    })
                    
                } else {
                    
                    List {
                        ForEach(filteredItems) { currentItem in
                            Label {
                                Text(currentItem.details)
                            } icon: {
                                Image(systemName: currentItem.isCompleted ? "checkmark.circle" : "circle")
                                    .onTapGesture {
                                        toggle(item: currentItem)
                                    }
                            }
                        }
                        .onDelete(perform: removeRows)
                    }
                }
            }
            .navigationTitle("Tasks")
        }
        .searchable(text: $searchText)
        .onAppear {
            // Populate with example data
            if items.isEmpty {
                //items.append(contentsOf: exampleData)
            }
        }
    }
    
    // MARK: Functions
    func addItem() {
        let newToDoItem = TodoItem(details: newItemDetails)
        items.insert(newToDoItem, at: 0)
        newItemDetails = ""
    }
    
    func toggle(item: TodoItem) {
        if item.isCompleted {
            item.completedOn = nil
            item.isCompleted = false
        } else {
            item.completedOn = Date()
            item.isCompleted = true
        }
        
    }
    
    func removeRows(at offsets: IndexSet) {
        //Remove items from the 'items' list
        items.remove(atOffsets: offsets)
    }
    
}

#Preview {
    LandingView()
}
