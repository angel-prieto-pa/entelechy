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
    
    private let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        
        WindowGroup {
            
            if let loadError = self.persistenceController.loadError {
                PersistenceErrorView(error: loadError)
            } else {
                HomeView(context: self.persistenceController.container.viewContext)
            }
            
        }
        
    }
    
}
