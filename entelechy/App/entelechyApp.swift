//
//  entelechyApp.swift
//  entelechy
//
//  Created by Angel Prieto on 11/28/25.
//

import SwiftUI
import CoreData

@main
struct entelechyApp: App {
    
    let persistenceContext = PersistenceController.shared.container.viewContext
    
    var body: some Scene {
        WindowGroup {
            HomeView(context: persistenceContext)
        }
    }
    
}
