//
//  ProgressSummaryView.swift
//  entelechy
//
//  Created by Angel Prieto on 4/25/26.
//

import SwiftUI

struct ProgressSummaryView: View {
    
    @ScaledMetric(relativeTo: .body) private var contentPadding: CGFloat = 10.0
    @ScaledMetric(relativeTo: .body) private var subcontentSpacing: CGFloat = 5.0
    @ScaledMetric(relativeTo: .body) private var scrollViewVerticalPadding: CGFloat = 2.0 * AppLayout.contentVerticalPadding
    
    private let displayCornerRadius: CGFloat = 30.0
    private let contentOutlineWidth: CGFloat = 1.5

    private let calendar = Calendar.current
    
    /* body */

    var body: some View {
        
        ScrollView {
            
            LazyVStack(alignment: .leading, spacing: 0.0, pinnedViews: [.sectionHeaders]) {
                
//                ForEach(WeightHistoryBuilder.buildWeightYears(from: self.viewModel.entryLog)) { weightYear in
//                    
//                    Section {
//                        
//                        ForEach(weightYear.weeks) { weightWeek in
//                            
//                            Text("Week \(weightWeek.week)")
//                                .font(.subheadline.weight(.medium))
//                                .foregroundStyle(.secondary)
//                                .underline()
//
//                                
//                            
//                        }
//                        .padding(.horizontal, self.scrollViewHorizontalPadding)
//                        .padding(.vertical, self.scrollViewVerticalPadding)
//                        
//                    } header: {
//                        
//                        // Year Header
//                        self.yearHeader(for: weightYear.year)
//                            .font(.subheadline.weight(.bold))
//                            .padding(AppLayout.contentOutlineWidth)
//                            .background(.background)
//                            
//                        
//                    }
                    
//                }
            }
            
        }
        .scrollIndicators(.hidden)
        .padding(.vertical, AppLayout.contentVerticalPadding)
        
    }
    
    // Year Header
    private func yearHeader(for year: Int) -> some View {
            
        Text(String(year))
            .font(.title3.weight(.semibold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
            .padding(self.contentPadding)
            .clipShape(RoundedRectangle(cornerRadius: self.displayCornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: self.displayCornerRadius, style: .continuous)
                    .stroke(AppColors.accent, lineWidth: self.contentOutlineWidth)
                )
            
            
            
    }
    
}
