//
//  TodoListView.swift
//  EnhancedTodolist
//
//  Created by Justin Hui on 20/1/2024.
//

import SwiftData
import SwiftUI

struct TodoListView: View {
    
    // MARK: Stored properties
    
    // Access the model context so we can "CRUD" data
    @Environment(\.modelContext) private var modelContext
    
    //The search term the user provides
    @State var searchText = ""
    
    // The item currently being created
    @State private var newItemDetails = ""
    
    // Run a query to obtain the list of to-do items
    @Query private var items: [TodoItem]
    
    // MARK: Computed properties
    
    //filtering the array of items
    var filteredItems: [TodoItem] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { item in
                item.details.lowercased().contains(searchText.lowercased())
            }
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
    }
    
    // MARK: Functions
    func addItem() {
        let newToDoItem = TodoItem(details: newItemDetails)
        modelContext.insert(newToDoItem)
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
        for offset in offsets {
            modelContext.delete(items[offset])
        }  
    }
}

#Preview {
    LandingView()
        .modelContainer(TodoItem.preview)
}
