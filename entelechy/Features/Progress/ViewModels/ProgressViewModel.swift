//
//  ProgressViewModel.swift
//  entelechy
//
//  Created by Angel Prieto on 4/29/26.
//

import Combine
import Foundation
import SwiftUI

final class ProgressViewModel: ObservableObject {
    
    /* structures */
    
    struct XAxisInfo {
        // Information that defines the visible date range and marker positions for the x-axis.
        let domain: ClosedRange<Date>
        let labels: [Date]
    }
    
    enum PlotRange: String, CaseIterable, Identifiable {
        // Types of time ranges users can view data for.
        
        case lengthMonth
        case lengthThreeMonth
        case lengthSixMonth
        case lengthYear
        case lengthAll
        
        var id: String { self.rawValue }
        
        var title: String {
            switch self {
            case .lengthMonth:
                return "1M"
            case .lengthThreeMonth:
                return "3M"
            case .lengthSixMonth:
                return "6M"
            case .lengthYear:
                return "1Y"
            case .lengthAll:
                return "All"
            }
        }
    }
    
    enum XAxisPeriodTypes {
        // Periods in which the x-axis can be defined by.
        
        case weeks
        case months
        case years
    }
    
    /* variables */
    
    @Published var selectedPlotLength: PlotRange = .lengthMonth
    
    private let repository: WeightEntryRepository
    private var cancellables: Set<AnyCancellable>
    
    private let calendar = Calendar.current
    
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
    
    /* computed properties */
    
    private var averageWeights: [WeightAverageYearModel] {
        /* Converts the array of sorted WeightYearModel instances from data stored, to return an array of sorted WeightAverageYearModel instances each year holding the average weight of the weeks, plus the difference between between prior weeks as instances of WeightWeekAverageModels. */
        
        var averageYears: [WeightAverageYearModel] = []
        
        self.repository.weightYears.forEach { weightYear in
            
            var averageWeeks: [WeightAverageWeekModel] = []
            
            weightYear.weeks.forEach { weightWeek in
                
                // Compute average of week.
                var total: Double = 0.0
                
                weightWeek.logs.forEach { entry in
                    total += entry.weight
                }
                
                let average = total / Double(weightWeek.logs.count)
                let averageRounded = (average * 10.0).rounded() / 10.0
                
                // Update prior week data with difference.
                let computedWeeks = averageWeeks.count
                let computedYears = averageYears.count
                
                if computedWeeks > 0 {
                    
                    // Update average week array.
                    let previousWeekIndex = computedWeeks - 1
                    let previousWeek = averageWeeks[previousWeekIndex]
                    let difference = previousWeek.average - averageRounded
                    
                    averageWeeks[previousWeekIndex] =
                        WeightAverageWeekModel(
                            startOfWeek: previousWeek.startOfWeek,
                            average: previousWeek.average,
                            difference: difference,
                            week: previousWeek.week
                        )
                    
                } else if computedYears > 0 {
                    
                    // Update previous year's last week.
                    let previousYearIndex = computedYears - 1
                    let previousYear = averageYears[previousYearIndex]
                    let previousYearWeeksCount = previousYear.weeks.count
                    
                    if previousYearWeeksCount > 0 {
                        
                        var previousWeeks = previousYear.weeks
                        let previousWeekIndex = previousYearWeeksCount - 1
                        let previousWeek = previousWeeks[previousWeekIndex]
                        let difference = previousWeek.average - averageRounded
                        
                        let lastWeek =
                            WeightAverageWeekModel(
                                startOfWeek: previousWeek.startOfWeek,
                                average: previousWeek.average,
                                difference: difference,
                                week: previousWeek.week
                            )
                        
                        // Update average week array, then year array.
                        previousWeeks[previousWeekIndex] = lastWeek
                        averageYears[previousYearIndex] = WeightAverageYearModel(year: previousYear.year, weeks: previousWeeks)
                        
                    }
                }
                
                // Create model.
                let averageWeekModel =
                    WeightAverageWeekModel(
                        startOfWeek: weightWeek.startOfWeek,
                        average: averageRounded,
                        difference: 0.0,
                        week: weightWeek.week)
                
                averageWeeks.append(averageWeekModel)
                
            }
            
            let averageYearModel = WeightAverageYearModel(year: weightYear.year, weeks: averageWeeks)
            
            averageYears.append(averageYearModel)
            
        }
        
        return averageYears
        
    }

    var averageYearsEnumerated: [(offset: Int, element: WeightAverageYearModel)] {
        /* Retrieves average weights over the years as an enumerated array. */
        Array(self.averageWeights.enumerated())
    }
    
    var chartEntries: [WeightEntryModel] {
        /* Retrieves weight entries in ascending date order for the selected range. */
        self.filteredEntries(for: self.selectedPlotLength)
    }
    
    var chartAverageWeeks: [WeightAverageWeekModel] {
        /* Retrieves weekly average weights in ascending date order for the selected range. */
        self.filteredAverageWeeks(for: self.selectedPlotLength)
    }
    
    /* public functions */
    
    func accentColor(for week: WeightAverageWeekModel) -> Color {
        /* Returns the accent color for the week, based on the difference from the previous week. */
        
        /* Note: A bit counterintuitively, but a loss of weight "-" would represent green and gain in weight "+" would be red. */
        
        if week.difference > 0 {
            return .red
        } else if week.difference < 0 {
            return .green
        } else {
            return .gray
        }
        
    }
    
    func differenceModifier(for week: WeightAverageWeekModel) -> String {
        /* Returns the text modifier for the week, based on the difference from the previous week. */
        
        if week.difference > 0 {
            return "+"
        } else if week.difference < 0 {
            return "-"
        } else {
            return ""
        }
        
    }
    
    private var sortedAverageWeeks: [WeightAverageWeekModel] {
        /* Returns average weights in a singular array from oldest to newest. */
        
        var averageWeeks = self.averageWeights
            .flatMap(\.weeks)
        
        averageWeeks.reverse()
        
        return averageWeeks
        
    }
    
    private func filteredEntries(for plotLength: PlotRange) -> [WeightEntryModel] {
        /* Filters entries for period selected. */
        
        let entries = self.repository.entries.sorted { $0.date < $1.date }
        
        let start = self.getXAxisDomain().lowerBound
        
        return entries.filter { $0.date >= start }
    }
    
    private func filteredAverageWeeks(for plotLength: PlotRange) -> [WeightAverageWeekModel] {
        /* Filters average week weights for period selected. */
        
        var averageWeeks = self.averageWeights
            .flatMap(\.weeks)
        
        averageWeeks.reverse()
        
        let start = self.getXAxisDomain().lowerBound
        
        return averageWeeks.filter { $0.startOfWeek >= start }
        
    }
    
    func getXAxisDomain() -> ClosedRange<Date> {
        /* Provides x-axis domain with a range of time dependent on period selected. */
        
        let currentDate: Date = Date()
        
        // Current month interval.
        guard let monthInterval = self.calendar.dateInterval(of: .month, for: currentDate) else {
            return currentDate...currentDate
        }
        
        // Current month start and end date.
        let monthStartDate = monthInterval.start
        guard let endDate = self.calendar.date(byAdding: .day, value: -1, to: monthInterval.end) else {
            return currentDate...currentDate
        }
        
        // Return domain based on selected period.
        switch self.selectedPlotLength {
            
        case .lengthMonth:
            
            return monthStartDate...endDate
            
        case .lengthAll:
            
            let averageBounds = self.getAverageWeeksBounds()
            
            return averageBounds.firstWeek...averageBounds.lastWeek
            
            
        default:
            
            let dates = self.getXAxisMarkers()
            
            guard let startDate = dates.first else {
                return currentDate...currentDate
            }
            
            return startDate...endDate
            
        }
        
    }
    
    func getYAxisDomain(entries: [WeightEntryModel], averages: [WeightAverageWeekModel], isEmpty: Bool) -> ClosedRange<Double> {
        /* Provides y-axis domain with a range of weight that provides space above and below. */
        
        if isEmpty {
            return 0.0...1.0
        }
        
        let weights = entries.map(\.weight) + averages.map(\.average)
        
        guard let minWeight = weights.min(), let maxWeight = weights.max() else {
            return 0.0...0.0
        }
        
        let midpoint = (minWeight + maxWeight) / 2.0
        let weightSpan = (maxWeight - minWeight) * 1.25
        let halfSpan = weightSpan / 2.0
        
        return (midpoint - halfSpan)...(midpoint + halfSpan)
        
    }
    
    private func getAverageWeeksBounds() -> (firstWeek: Date, lastWeek: Date) {
        /* Returns the start of week dates for the first and last averaged weeks. */
        
        guard let firstAverage = self.sortedAverageWeeks.first, let lastAverage = self.sortedAverageWeeks.last else {
            return (Date(), Date())
        }
        
        return (firstAverage.startOfWeek, lastAverage.startOfWeek)
        
    }
    
    func getXAxisMarkers() -> [Date] {
        /* Returns dates that will be marked along the x-axis. */
        
        guard let monthInterval = self.calendar.dateInterval(of: .month, for: Date()), let monthEnd = self.calendar.date(
            byAdding: .day,
            value: -1,
            to: monthInterval.end) else {
            return []
        }
        
        let monthStart = monthInterval.start
        
        // Provide appropriate parameters to iterate through range.
        
        var periodEnd = monthEnd
        let range: Int
        let periodType: XAxisPeriodTypes
        
        switch self.selectedPlotLength {
            
            case .lengthMonth:
            
            guard let firstWeekStartOfMonth = self.calendar.dateInterval(of: .weekOfYear, for: monthStart)?.start else {
                return []
            }
            
            let currentMonth = self.calendar.component(.month, from: monthStart)
            let firstWeekMonth = self.calendar.component(.month, from: firstWeekStartOfMonth)
            
            let rangeOfMonth = Calendar.current.dateComponents([.weekOfYear], from: firstWeekStartOfMonth, to: monthEnd)
            
            guard let rangeMonth = rangeOfMonth.weekOfYear else {
                return []
            }

            range = rangeMonth - (currentMonth == firstWeekMonth ? 0 : 1)
            periodType = .weeks
            
            case .lengthThreeMonth:
            range = 2
            periodType = .months
            
            case .lengthSixMonth:
            range = 5
            periodType = .months
            
            case .lengthYear:
            range = 11
            periodType = .months
            
            case .lengthAll:
            
            let averageBounds = self.getAverageWeeksBounds()
            
            guard let monthRange = Calendar.current.dateComponents([.month], from: averageBounds.firstWeek, to: averageBounds.lastWeek).month else {
                return []
            }
            
            if monthRange < 1 {
                
                guard let weekRange = Calendar.current.dateComponents([.weekOfYear], from: averageBounds.firstWeek, to: averageBounds.lastWeek).weekOfYear else {
                    return []
                }
                
                range = max(weekRange, 1)
                periodType = .weeks
                periodEnd = averageBounds.lastWeek
                
            } else if monthRange < 12 {
                
                periodType = .months
                range = monthRange
                
            } else {
                periodType = .years
                range = monthRange / 12
            }
            
        }
        
        return self.generateXAxisMarkers(upTo: periodEnd, spanning: range, by: periodType)
        
    }
 
   private func generateXAxisMarkers(upTo periodEnd: Date, spanning periodRange: Int, by periodType: XAxisPeriodTypes) -> [Date] {
       /* Returns dates of x-axis markers by iterating through period and span. */
        
        var dates: [Date] = []
        
        let today: Date = self.calendar.startOfDay(for: Date())
        var todayNotMarked: Bool = true
        
        // Adjust appropriate period component.
        let periodComponet: Calendar.Component
        
        switch periodType {
            
        case .weeks:
            periodComponet = .weekOfYear
        case .months:
            periodComponet = .month
        case .years:
            periodComponet = .year
            
        }
        
        // Find start of period based on range.
        guard
            let periodStart = self.calendar.dateInterval(of: periodComponet, for: periodEnd)?.start,
            let dateStart = self.calendar.date(byAdding: periodComponet, value: -1 * periodRange, to: periodStart)
        else {
            return dates
        }
        
        var date: Date = dateStart
        
        // Iterate through period.
        while date <= periodEnd {
            
            // Append current day, unless it is already a date being iterated on.
            if today == date {
                todayNotMarked = false
            } else if (today < date) && todayNotMarked {
                todayNotMarked = false
                dates.append(today)
            }
            
            // Append dates of appropropiate period markers.
            dates.append(date)
            
            // Increase date by period component.
            if let nextDate = self.calendar.date(byAdding: periodComponet, value: 1, to: date) {
                date = nextDate
            } else {
                break
            }
            
        }
        
        return dates
       
    }
    
}
