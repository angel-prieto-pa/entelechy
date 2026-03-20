//
//  WeightEntryModel.swift
//  entelechy
//
//  Created by Angel Prieto on 11/28/25.
//

import Foundation
import CoreData

struct WeightEntryModel: Identifiable {
    let id: NSManagedObjectID
    
    let date: Date
    let weight: Double
}

