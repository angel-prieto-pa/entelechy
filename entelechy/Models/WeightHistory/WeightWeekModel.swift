//
//  WeightWeekModel.swift
//  entelechy
//
//  Created by Angel Prieto on 4/14/26.
//

import Foundation

struct WeightWeekModel: Identifiable {
    
    let startOfWeek: Date
    var id: Date { startOfWeek }
    
    let logs: [WeightEntryModel]

    let week: Int
    var year: Int {
        Calendar.current.component(.year, from: startOfWeek)
    }
    
}

