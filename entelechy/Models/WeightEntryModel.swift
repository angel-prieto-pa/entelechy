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
        WeightEntryModel(id: NSManagedObjectID(), date: Calendar.current.date(from: DateComponents(year: 2026, month: 2, day: 1))!, weight: 100.4)
    ]
}
