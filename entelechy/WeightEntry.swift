//
//  WeightEntry.swift
//  entelechy
//
//  Created by Angel Prieto on 11/28/25.
//

import Foundation

struct WeightEntry: Identifiable {
    let id = UUID()
    
    let date: Date
    let weight: Double
}
