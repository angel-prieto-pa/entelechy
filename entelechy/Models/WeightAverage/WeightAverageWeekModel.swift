//
//   WeightAverageWeekModel.swift
//  entelechy
//
//  Created by Angel Prieto on 4/29/26.
//

import Foundation

struct WeightAverageWeekModel: Identifiable {
    
    let startOfWeek: Date
    var id: Date { startOfWeek }
    
    let average: Double
    let difference: Double

    let week: Int
    var year: Int {
        Calendar.current.component(.year, from: startOfWeek)
    }
    
}
