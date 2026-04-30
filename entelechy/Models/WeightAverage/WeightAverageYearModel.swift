//
//  WeightAverageYearModel.swift
//  entelechy
//
//  Created by Angel Prieto on 4/29/26.
//

import Foundation

struct WeightAverageYearModel: Identifiable {
    
    let year: Int
    var id: Int { year }
    
    let weeks: [WeightAverageWeekModel]
    
}
