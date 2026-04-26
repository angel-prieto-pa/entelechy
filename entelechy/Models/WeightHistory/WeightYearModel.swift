//
//  WeightYearModel.swift
//  entelechy
//
//  Created by Angel Prieto on 4/23/26.
//

import Foundation

struct WeightYearModel: Identifiable {
    
    let year: Int
    var id: Int { year }
    
    let weeks: [WeightWeekModel]
    
}
