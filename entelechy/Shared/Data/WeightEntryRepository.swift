//
//  WeightEntryRepository.swift
//  entelechy
//
//  Created by Angel Prieto on 4/26/26.
//

import Combine
import CoreData

final class WeightEntryRepository: ObservableObject {
    
    /* variables */
    
    @Published private(set) var entries: [WeightEntryModel]
    @Published private(set) var weightYears: [WeightYearModel]

    private let context: NSManagedObjectContext
    private var contextObserver: NSObjectProtocol?
    
    /* init */

    init(context: NSManagedObjectContext) {
        
        self.context = context
        
        self.entries = []
        self.weightYears = []
        
        // Initialize data observer.
        self.contextObserver = NotificationCenter.default.addObserver(
            forName: .NSManagedObjectContextDidSave,
            object: context,
            queue: .main
        ) { [weak self] _ in
            // Update local data in the case of observed changes.
            self?.refreshLocalData()
        }

        self.refreshLocalData()
        
    }
    
    /* functions */
    
    deinit {
        if let contextObserver {
            NotificationCenter.default.removeObserver(contextObserver)
        }
    }
    
    func refreshLocalData() {
        /* Update local data to match Core Data. */
        
        do {
            
            self.entries = try WeightEntry.fetchEntries(from: context)
            self.weightYears = self.buildWeightYears()
            
        } catch {
            
            print("Error - Unable to fetch data:", error)
            
        }
        
    }
    
    func addEntry(weight: Double, on date: Date = Date()) {
        /* Create and save a weight entry. */
        
        let entry = WeightEntry(context: self.context)
        entry.date = date
        entry.weight = weight
        
        do {
            try self.context.save()
        } catch {
            print("Error - Unable to save data:", error)
        }
    }
    
    private func buildWeightWeeks() -> [WeightWeekModel] {
        /* Returns an array of sorted WeightWeekModel instances, each week holding the sorted weight logs for the week as WeightEntryModel. */

        
        let entryLogs = self.entries
        
        let calendar = Calendar.current

        // Grouped logs by week start.
        let grouped = Dictionary(grouping: entryLogs) { entry in

            let interval = calendar.dateInterval(of: .weekOfYear, for: entry.date)!
                
            // Splits weeks that cross year boundaries (e.g., Dec 28, 2025 should not include Jan 1, 2026).
            let intervalStartYear = calendar.component(.year, from: interval.start)
            let entryYear = calendar.component(.year, from: entry.date)
                
            if intervalStartYear != entryYear {
                    
                let startOfYear = calendar.date(from: DateComponents(year: entryYear, month: 1, day: 1))!
                
                return startOfYear
                    
            }
            
            return interval.start
            
        }

        // Grouped week logs of 'WeightEntryModel' by their week number.
        let weeks = grouped.map { (startOfWeek, logs) in
            
            // Computes week number based on the start of the week (e.g., Week 1 for Jan 1, 2026, with it only being partially full at 3 days).
            let yearStart = calendar.date(from: DateComponents(year: calendar.component(.year, from: startOfWeek), month: 1, day: 1))!
            let yearIntervalStart = calendar.dateInterval(of: .weekOfYear, for: yearStart)!
            let yearWeekStart = yearIntervalStart.start
                
            let days = calendar.dateComponents([.day], from: yearWeekStart, to: startOfWeek).day ?? 0
                
            let weekNumber = (days / 7) + 1

            return WeightWeekModel(
                startOfWeek: startOfWeek,
                logs: logs.sorted { $0.date > $1.date },
                week: weekNumber
            )
            
        }

        // Weeks sorted in descending order.
        return weeks.sorted { $0.startOfWeek > $1.startOfWeek }
        
    }
    
    private func buildWeightYears() -> [WeightYearModel] {
        /* Returns an array of sorted WeightYearModel instances, each year holding the sorted weeks for the year as WeightWeekModel. */
        
        var years: [WeightYearModel] = []
        
        let weeks = self.buildWeightWeeks()
        
        var currentYear: Int?
        var currentWeeks: [WeightWeekModel] = []

        for week in weeks {
            
            if week.year == currentYear {
                currentWeeks.append(week)
                
            } else {
                
                if let currentYear {
                    years.append(WeightYearModel(year: currentYear, weeks: currentWeeks))
                }

                currentYear = week.year
                currentWeeks = [week]
                
            }
            
        }

        if let currentYear {
            years.append(WeightYearModel(year: currentYear, weeks: currentWeeks))
        }

        return years
        
    }
    
    
}
