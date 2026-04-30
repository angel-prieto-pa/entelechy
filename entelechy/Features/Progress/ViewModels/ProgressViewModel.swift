//
//  ProgressViewModel.swift
//  entelechy
//
//  Created by Angel Prieto on 4/29/26.
//

import Combine
import Foundation

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
    
    var averageDictionary: [WeightAverageYearModel] {
        /* Converts the array of sorted WeightYearModel instances from data stored, to return an array of sorted WeightAverageYearModel instances each year holding the average weight of the weeks for the year as instances of  WeightWeekAverageModels. */
        
        var averageYears: [WeightAverageYearModel] = []
        
        self.repository.weightYears.forEach { weightYear in
            
            var averageWeeks: [WeightAverageWeekModel] = []
            
            weightYear.weeks.forEach { weightWeek in
                
                var total: Double = 0.0
                
                weightWeek.logs.forEach { entry in
                    total += entry.weight
                }
                
                let average = total / Double(weightWeek.logs.count)
                let averageRounded = (average * 10.0).rounded() / 10.0
                
                let averageWeekModel = WeightAverageWeekModel(startOfWeek: weightWeek.startOfWeek, average: averageRounded, week: weightWeek.week)
                
                averageWeeks.append(averageWeekModel)
                
            }
            
            let averageYearModel = WeightAverageYearModel(year: weightYear.year, weeks: averageWeeks)
            
            averageYears.append(averageYearModel)
            
        }
        
        return averageYears
        
    }
    
}
