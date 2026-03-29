//
//  HistoryLogView.swift
//  entelechy
//
//  Created by Angel Prieto on 03/15/26.
//


import SwiftUI

struct HistoryLogView: View {
    
    @ObservedObject var viewModel: LogEntryViewModel

    var body: some View {
        
        // Logs
        List(viewModel.entryLog.reversed()) { entry in
            
            HStack {
                
                Text("\(entry.weight, specifier: "%.1f") \(viewModel.unitLabel)")
                
                Spacer()
                
                Text(entry.date, style: .date)
                    .foregroundColor(.secondary)
                
            }
        }
    }
    
}
