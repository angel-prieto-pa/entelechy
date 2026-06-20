//
//  PersistenceController.swift
//  entelechy
//
//  Created by Angel Prieto on 3/19/26.
//

import CoreData

struct PersistenceController {
    
    static let shared = PersistenceController()

    let container: NSPersistentContainer
    let loadError: Error?

    init() {
        
        self.container = NSPersistentContainer(name: "WeightModel")
        
        var persistentStoreLoadError: Error?
        
        self.container.loadPersistentStores { _, error in
            if let error {
                persistentStoreLoadError = error
            }
        }
        
        // Error state in case of fail to load data.
        self.loadError = persistentStoreLoadError
        
    }
    
}
