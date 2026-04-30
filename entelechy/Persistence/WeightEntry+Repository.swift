//
//  WeightEntry+Repository.swift
//  entelechy
//
//  Created by Angel Prieto on 4/25/26.
//

import CoreData

extension WeightEntry {

    static func fetchEntries(from context: NSManagedObjectContext) throws -> [WeightEntryModel] {
        
        let request = WeightEntry.fetchRequest()
        return WeightEntryModel.mockWeightData
//        return try context.fetch(request).compactMap { $0.toModel() }
        
    }
    
}
