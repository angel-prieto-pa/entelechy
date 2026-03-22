//
//  LogEntryViewModel.swift
//  entelechy
//
//  Created by Angel Prieto on 11/28/25.
//

import SwiftUI
import Combine
import CoreData

final class LogEntryViewModel: ObservableObject {
    
    @Published var currentLog: String = ""
    @Published private(set) var entryLog: [WeightEntryModel] = []
    @Published private(set) var entryDictionary: [Date: Double] = [:]

    private let context: NSManagedObjectContext

    let unitLabel: String = "lbs."

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchEntries()
    }

    // TODO: - validate weight and disable submit after
    var isSubmitEnabled: Bool {
        return true
    }

    func fetchEntries() {
        /* Fetches 'WeightEntry' objects from CoreData and updates 'entryLog' after converting data in accordance to 'WeightEntryModel'. */
        
        let request: NSFetchRequest<WeightEntry> = WeightEntry.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \WeightEntry.date, ascending: false)]

        do {
            entryLog = try context.fetch(request).compactMap { $0.toModel() }
            entryDictionary = Dictionary(uniqueKeysWithValues: entryLog.map { (Calendar.current.startOfDay(for: $0.date), $0.weight) })
        } catch {
            print("Error - Unable to fetch data:", error)
            entryLog = []
            entryDictionary = [:]
        }
    }

    func submitWeight() {
        let weight = validatedWeight

        let entry = WeightEntry(context: context)
        entry.date = Date()
        entry.weight = weight

        do {
            try context.save()
            fetchEntries()
        } catch {
            print("Error - Unable to save data: ", error)
        }

        currentLog = ""
    }

    func updateInput(_ newValue: String) {
        /* Called when user is inputting a weight log. */
        
        // Ensures log is sanitized.
        self.currentLog = sanitizeInput(newValue)
    }
    
    private func sanitizeInput(_ input: String) -> String {
        /* Called by 'updateInput' to sanitize log being inputted. */
        
        // Return empty string in case input is empty.
        if input.count == 0 {
            return ""
        }
        
        // Remove all characters that are not numbers or a decimal from input.
        var filtered = input.filter { $0.isNumber || $0 == "." }
        
        // Add 0 to start if first character is a decimal.
        if filtered.first == "." {
            filtered = "0" + filtered
        }

        // Split input by decimal. Since our the maximum value our log allows is up to 999.9, our whole value would be up to the first 3 digits input. If there is no decimal in input the fourth digit would be our fractional, otherwise the first digit after the decimal would be our fractional. If there is no decimal the fractional is empty.
        let parts = filtered.split(separator: ".", omittingEmptySubsequences: false)
        
        let first = String(parts[0])
        
        let whole = String(first.prefix(3))
        let fractional: String

        if parts.count == 1 && first.count > 3 {
            fractional = "." + String(first.dropFirst(3).prefix(1))
        } else if parts.count > 1 {
            fractional = "." + String(parts[1].prefix(1))
        } else {
            fractional = ""
        }

        return whole + fractional
    }

    private var validatedWeight: Double {
        /* Double check to validate weight and return input as a double. */
        
        guard let value = Double(self.currentLog), value >= 000.0, value <= 999.9 else {
            // TODO: throw error
            return 0.0
        }
        
        return value
        
    }
    
}
