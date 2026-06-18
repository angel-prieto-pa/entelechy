//
//  EmptyStateView.swift
//  entelechy
//
//  Created by Angel Prieto on 6/17/26.
//

import SwiftUI

struct EmptyStateView: View {
    
    /* structures */
    
    enum EmptyStateType {
        // Supported empty states with their display text.
        
        case progressSummary
        case progressChart
        case historyLog
        
        var title: String {
            switch self {
            case .progressSummary:
                return "No progress data available."
            case .progressChart:
                return "No chart data available."
            case .historyLog:
                return "No history data available."
            }
        }
        
        var message: String {
            switch self {
            case .progressSummary:
                return "Log a few weights to see entries and weekly averages over time."
            case .progressChart:
                return "Log a few weights to see your weight trends across a chart."
            case .historyLog:
                return "Log a few weights to see your weight history over time."
            }
        }
        
    }
    
    /* variables */
    
    let type: EmptyStateType
    
    @ScaledMetric(relativeTo: .body) private var contentSpacing: CGFloat = 2.0 * AppLayout.contentVerticalPadding
    
    /* body */
    
    var body: some View {
        
        VStack(alignment: .center, spacing: self.contentSpacing) {
            Text(self.type.title)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary)
            
            Text(self.type.message)
                .font(.subheadline.weight(.regular))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, self.contentSpacing)
        }
        
    }
    
}
