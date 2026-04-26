//
//  WeightHistoryBuilder.swift
//  entelechy
//
//  Created by Angel Prieto on 4/23/26.
//

import Foundation

enum WeightHistoryBuilder {
    
    private static func buildWeightWeeks(from entryLogs: [WeightEntryModel]) -> [WeightWeekModel] {
        
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
    
    static func buildWeightYears(from entryLogs: [WeightEntryModel]) -> [WeightYearModel] {
        /* Returns an array of WeightYearModel instances, each year holding the sorted weeks for the year as WeightWeekModel. */
        
        let weeks: [WeightWeekModel] = WeightHistoryBuilder.buildWeightWeeks(from: entryLogs)

        var years: [WeightYearModel] = []
        
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
