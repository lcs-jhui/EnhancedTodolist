//
//  EnhancedTodolistApp.swift
//  EnhancedTodolist
//
//  Created by Justin Hui on 20/1/2024.
//

import SwiftData
import SwiftUI

@main
struct EnhancedTodolistApp: App {
    var body: some Scene {
        WindowGroup {
            LandingView()
        }
        .modelContainer(for: TodoItem.self)
    }
}
