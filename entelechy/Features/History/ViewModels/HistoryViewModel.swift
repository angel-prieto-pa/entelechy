//
//  HistoryViewModel.swift
//  entelechy
//
//  Created by Angel Prieto on 4/25/26.
//

import Combine
import Foundation

final class HistoryViewModel: ObservableObject {
    
    /* variables */
    
    private let repository: WeightEntryRepository
    private var cancellables: Set<AnyCancellable>
    
    private let calendar = Calendar.current
    
    /* computed properties */
    
    private var entries: [WeightEntryModel] {
        /* Retreives entries from repository. */
        self.repository.entries
    }
    
    private var loggedDaySet: Set<Date> {
        /* Converts arry of logged entries into a normalized set, in order to simplify checking days in which there is a log. */
        
        Set(self.entries.map { entry in
            self.calendar.startOfDay(for: entry.date)
        })
    }
    
    private var entryDictionary: [Date: Double] {
        /* Converts array of logged entries into a dictionary holding on the weight and its corresponding date as the key. */
        
        Dictionary(
            self.entries.map {
                (self.calendar.startOfDay(for: $0.date), $0.weight)
            },
            uniquingKeysWith: { _, old in old }
        )
        
    }
    
    var weightYears: [WeightYearModel] {
        /* Retrieves weightYears from repository. */
        self.repository.weightYears
    }
    
    /* init */

    init(repository: WeightEntryRepository) {
        
        self.repository = repository
        self.cancellables = []
        
        repository.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &self.cancellables)
        
    }
    
    /* public functions */
    
    func hasEntry(on date: Date) -> Bool {
        /* Returns whether there is a log for date provided. */
        return self.loggedDaySet.contains(self.normalized(date))
    }
    
    func weight(on date: Date) -> Double? {
        /* Returns whether there is a weight for date provided. */
        return self.entryDictionary[self.normalized(date)]
    }
    
    /* helper functions */
    
    private func normalized(_ date: Date) -> Date {
        /* Normalizes dates to start of day. */
        return self.calendar.startOfDay(for: date)
    }
    
}
