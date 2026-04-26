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

extension WeightEntryModel {
    
    static let mockWeightData: [WeightEntryModel] = [
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 12))!, weight: 101.2),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 10))!, weight: 100.6),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 8))!, weight: 102.1),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 6))!, weight: 101.8),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 4, day: 3))!, weight: 99.7),

        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 3, day: 30))!, weight: 100.9),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 3, day: 28))!, weight: 101.5),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 3, day: 25))!, weight: 102.3),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 3, day: 22))!, weight: 99.8),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 3, day: 20))!, weight: 100.2),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 3, day: 18))!, weight: 101.9),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 3, day: 15))!, weight: 103.1),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 3, day: 12))!, weight: 102.7),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 3, day: 10))!, weight: 101.4),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 3, day: 7))!, weight: 100.3),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 3, day: 5))!, weight: 99.6),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 3, day: 2))!, weight: 100.8),

        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 28))!, weight: 101.1),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 26))!, weight: 102.4),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 23))!, weight: 103.0),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 20))!, weight: 101.7),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 18))!, weight: 100.5),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 15))!, weight: 99.9),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 12))!, weight: 100.7),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 9))!, weight: 101.3),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 6))!, weight: 102.2),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 3))!, weight: 101.0),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 1))!, weight: 100.4),
        
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 29))!, weight: 100.8),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 26))!, weight: 101.5),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 23))!, weight: 102.1),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 20))!, weight: 103.0),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 17))!, weight: 102.6),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 14))!, weight: 101.9),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 11))!, weight: 102.4),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 8))!, weight: 103.3),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 5))!, weight: 104.0),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 1, day: 2))!, weight: 103.6),

        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 12, day: 30))!, weight: 104.2),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 12, day: 27))!, weight: 105.0),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 12, day: 24))!, weight: 105.6),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 12, day: 21))!, weight: 106.3),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 12, day: 18))!, weight: 105.8),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 12, day: 15))!, weight: 104.9),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 12, day: 12))!, weight: 105.5),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 12, day: 9))!, weight: 106.1),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 12, day: 6))!, weight: 106.8),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 12, day: 3))!, weight: 107.2),

        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 11, day: 30))!, weight: 107.8),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 11, day: 27))!, weight: 108.5),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 11, day: 24))!, weight: 109.2),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 11, day: 21))!, weight: 108.7),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 11, day: 18))!, weight: 107.9),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 11, day: 15))!, weight: 108.3),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 11, day: 12))!, weight: 109.0),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 11, day: 9))!, weight: 109.6),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 11, day: 6))!, weight: 110.2),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 11, day: 3))!, weight: 110.8),

        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 31))!, weight: 111.3),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 28))!, weight: 112.0),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 25))!, weight: 112.6),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 22))!, weight: 113.2),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 19))!, weight: 112.7),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 16))!, weight: 113.5),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 13))!, weight: 114.1),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 10))!, weight: 114.8),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 7))!, weight: 115.3),
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 4))!, weight: 116.0)
    ]
}
