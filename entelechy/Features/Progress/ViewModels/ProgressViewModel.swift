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
    
    enum PlotTimeRange: String, CaseIterable, Identifiable {
        // Supported time ranges for the plot.
        
        case rangeMonth
        case rangeThreeMonth
        case rangeSixMonth
        case rangeYear
        case rangeAll
        
        var id: String { self.rawValue }
        
        var title: String {
            switch self {
            case .rangeMonth:
                return "1M"
            case .rangeThreeMonth:
                return "3M"
            case .rangeSixMonth:
                return "6M"
            case .rangeYear:
                return "1Y"
            case .rangeAll:
                return "All"
            }
        }
        
    }
    
    struct XAxisConfiguration {
        // Information necessary to render the chart's x-axis.
        
        let domain: ClosedRange<Date>
        let markers: [Date]
        let labelFormat: Date.FormatStyle
        
    }
    
    /* variables */
    
    @Published var selectedPlotTimeRange: PlotTimeRange = .rangeMonth
    @Published private var averageWeights: [WeightAverageYearModel]
    
    private let repository: WeightEntryRepository
    private var cancellables: Set<AnyCancellable>
    
    private let calendar = Calendar.current
    private let calendarUtilities = CalendarUtilities()
    
    /* init */
    
    init(repository: WeightEntryRepository) {
        
        self.repository = repository
        self.averageWeights = Self.makeAverageWeights(from: repository.weightYears)
        self.cancellables = []
        
        repository.$weightYears
            .receive(on: RunLoop.main)
            .sink { [weak self] weightYears in
                self?.averageWeights = Self.makeAverageWeights(from: weightYears)
            }
            .store(in: &self.cancellables)
        
        repository.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &self.cancellables)
        
    }
    
    /* computed properties */
    
    private var averageWeightWeeks: [WeightAverageWeekModel] {
        /* Flattens yearly average weights into a single array of weekly averages. */
        self.averageWeights.flatMap(\.weeks)
    }

    var averageYearsEnumerated: [(offset: Int, element: WeightAverageYearModel)] {
        /* Retrieves average weights over the years as an enumerated array. */
        Array(self.averageWeights.enumerated())
    }
    
    var chartEntries: [WeightEntryModel] {
        /* Retrieves weight entries in ascending date order for the selected range. */
        self.filteredEntries()
    }
    
    var chartAverageWeeks: [WeightAverageWeekModel] {
        /* Retrieves weekly average weights in ascending date order for the selected range. */
        self.filteredAverageWeeks()
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
    
    func getXAxisConfiguration() -> XAxisConfiguration {
        /* Builds the x-axis domain, marker dates, and label format for the selected chart range. */
        
        let domain = self.getXAxisDomain()
        let (markers, labelFormat) = self.getXAxisMarkerInformation(for: domain)
        
        return XAxisConfiguration(domain: domain, markers: markers, labelFormat: labelFormat)
        
    }
    
    func getYAxisDomain() -> ClosedRange<Double> {
        /* Provides y-axis domain with a range of weight that provides space above and below. */
        
        let entries = self.chartEntries
        let averages = self.chartAverageWeeks
        
        if entries.isEmpty {
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
    
    /* private functions */
    
    private func getXAxisDomain() -> ClosedRange<Date> {
        /* Returns the x-axis domain for the selected time range. */
        
        let currentMonthBounds = self.calendarUtilities.monthBounds()
        
        let currentMonthStart = currentMonthBounds.lowerBound
        let currentMonthEnd = currentMonthBounds.upperBound
        
        // Return domain based on selected period.
        switch self.selectedPlotTimeRange {
            
        case .rangeMonth:
            
            return currentMonthStart...currentMonthEnd
            
        case .rangeThreeMonth, .rangeSixMonth, .rangeYear:
            
            let monthOffset: Int

            switch self.selectedPlotTimeRange {
                
            case .rangeThreeMonth:
                monthOffset = -2
            case .rangeSixMonth:
                monthOffset = -5
            case .rangeYear:
                monthOffset = -11
            default:
                monthOffset = 0
                
            }

            let monthStart = self.calendarUtilities.date(byAdding: .month, amount: monthOffset, to: currentMonthStart)

            return monthStart...currentMonthEnd
            
        case .rangeAll:
            
            let data = self.averageWeightWeeks
            
            guard var start = data.last?.startOfWeek,
                  var end = data.first?.startOfWeek else {
                return Date()...Date()
            }
            
            if start == end {
                start = self.calendarUtilities.startDate(of: .weekOfYear, for: start)
                end = self.calendar.date(byAdding: .day, value: 7, to: start) ?? start
            }

            return start...end
            
        }
        
    }
    
    private func getXAxisMarkerInformation(for domain: ClosedRange<Date>) -> ([Date], Date.FormatStyle) {
        /* Returns dates that will be marked along the x-axis. */
        
        var domainStart = domain.lowerBound
        let domainEnd = domain.upperBound
        
        // Provide appropriate interval type to iterate through range.
        
        let intervalComponet: Calendar.Component
        let labelFormat: Date.FormatStyle
        
        switch self.selectedPlotTimeRange {
            
            case .rangeMonth:
            intervalComponet = .weekOfYear
            labelFormat = .dateTime.month(.abbreviated).day()
            
            // Find the first start of week for the month.
            let domainFirstWeek = self.calendarUtilities.startDate(of: .weekOfYear, for: domainStart)
            
            if domainFirstWeek < domainStart {
                domainStart = self.calendarUtilities.date(byAdding: .weekOfYear, amount: 1, to: domainFirstWeek)
            } else {
                domainStart = domainFirstWeek
            }
            
            case .rangeThreeMonth:
            intervalComponet = .month
            labelFormat = .dateTime.month(.abbreviated)
            
            case .rangeSixMonth:
            intervalComponet = .month
            labelFormat = .dateTime.month(.abbreviated)
            
            case .rangeYear:
            intervalComponet = .month
            labelFormat = .dateTime.month(.abbreviated)
            
            case .rangeAll:
            
            // Adjust interval type based on length of range.
            let monthRange = self.calendarUtilities.count(of: .month, from: domainStart, to: domainEnd)
            
            if monthRange < 2 {
                intervalComponet = .weekOfYear
                labelFormat = .dateTime.month(.abbreviated).day()
            } else if monthRange < 24 {
                intervalComponet = .month
                labelFormat = .dateTime.month(.abbreviated)
            } else {
                intervalComponet = .year
                labelFormat = .dateTime.year()
            }
            
        }
        
        return (self.generateXAxisMarkers(for: domainStart...domainEnd, by: intervalComponet), labelFormat)
        
    }
    
    private func filteredEntries() -> [WeightEntryModel] {
        /* Filters entries for period selected. */
        
        let entries = self.repository.entries.sorted { $0.date < $1.date }
        
        let domain = self.getXAxisDomain()
        let start = domain.lowerBound
        let end = domain.upperBound
        
        return entries.filter { $0.date >= start && $0.date <= end}
    }
    
    private func filteredAverageWeeks() -> [WeightAverageWeekModel] {
        /* Filters average week weights for period selected. */
        
        var averageWeeks = self.averageWeightWeeks
        
        averageWeeks.reverse()
        
        let domain = self.getXAxisDomain()
        let start = domain.lowerBound
        let end = domain.upperBound
        
        return averageWeeks.filter { $0.startOfWeek >= start && $0.startOfWeek <= end}
        
    }
 
    private func generateXAxisMarkers(for range: ClosedRange<Date>, by intervalComponet: Calendar.Component) -> [Date] {
       /* Returns dates of x-axis markers by iterating through range by interval. */
        
        var dates: [Date] = []
        
        var date: Date = range.lowerBound
        
        // Iterate through period.
        while date <= range.upperBound {
            
            // Append dates of appropropiate period markers.
            dates.append(date)
            
            // Increase date by period component.
            date = self.calendarUtilities.date(byAdding: intervalComponet, amount: 1, to: date)
            
        }
        
        return dates
       
    }
    
    private static func makeAverageWeights(from weightYears: [WeightYearModel]) -> [WeightAverageYearModel] {
        /* Converts sorted weight years into yearly weekly-average models with week-over-week differences. */
        
        var averageYears: [WeightAverageYearModel] = []
        
        weightYears.forEach { weightYear in
            
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
    
}
