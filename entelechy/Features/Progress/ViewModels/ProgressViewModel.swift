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
    
    /* variables */
    
    private let repository: WeightEntryRepository
    private var cancellables: Set<AnyCancellable>
    
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
    
    /* public functions */
    
    func accentColor(for week: WeightAverageWeekModel) -> Color {
        /* Returns the accent color for the week, based on the difference from the previous week. */
        
        
        if week.difference > 0 {
            return .green
        } else if week.difference < 0 {
            return .red
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
    
}
