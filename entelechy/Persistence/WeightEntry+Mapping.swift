//
//  WeightEntry+Mapping.swift
//  entelechy
//
//  Created by Angel Prieto on 3/19/26.
//

import CoreData

extension WeightEntry {
    
    func toModel() -> WeightEntryModel? {
        
        guard let date else { return nil }

        return WeightEntryModel(
            id: objectID,
            
            date: date,
            weight: weight
        )
        
    }
    
}
