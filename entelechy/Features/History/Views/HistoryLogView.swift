//
//  HistoryLogView.swift
//  entelechy
//
//  Created by Angel Prieto on 03/15/26.
//

import SwiftUI

struct HistoryLogView: View {
    
    /* variables */

    @ObservedObject var viewModel: LogEntryViewModel
    
    @ScaledMetric(relativeTo: .body) private var contentPadding: CGFloat = 10.0
    @ScaledMetric(relativeTo: .body) private var subcontentSpacing: CGFloat = 5.0
    @ScaledMetric(relativeTo: .body) private var scrollViewVerticalPadding: CGFloat = 2.0 * AppLayout.contentVerticalPadding
    
    private let displayCornerRadius: CGFloat = 30.0
    private let contentOutlineWidth: CGFloat = 1.5
    
    private var scrollViewHorizontalPadding: CGFloat {
        self.contentPadding + AppLayout.contentOutlineWidth
    }

    private let calendar = Calendar.current

//    init(viewModel: LogEntryViewModel) {
//        self.viewModel = viewModel
//    }
    
    /* body */

    var body: some View {
        
        ScrollView {
            
            LazyVStack(alignment: .leading, spacing: 0.0, pinnedViews: [.sectionHeaders]) {
                
                ForEach(WeightHistoryBuilder.buildWeightYears(from: self.viewModel.entryLog)) { weightYear in
                    
                    Section {
                        
                        ForEach(weightYear.weeks) { weightWeek in
                            
                            VStack(alignment: .leading, spacing: self.subcontentSpacing) {
                                Text("Week \(weightWeek.week)")
                                    .font(.subheadline.weight(.medium))
                                    .foregroundStyle(.secondary)
                                    .underline()

                                ForEach(weightWeek.logs) { log in
                                    self.logRow(for: log)
                                }
                                .padding(.horizontal, self.contentPadding)
                                
                            }
                            
                        }
                        .padding(.horizontal, self.scrollViewHorizontalPadding)
                        .padding(.vertical, self.scrollViewVerticalPadding)
                        
                    } header: {
                        
                        // Year Header
                        self.yearHeader(for: weightYear.year)
                            .font(.subheadline.weight(.bold))
                            .padding(AppLayout.contentOutlineWidth)
                            .background(.background)
                            
                        
                    }
                    
                }
            }
            
        }
        .scrollIndicators(.hidden)
        .padding(.vertical, AppLayout.contentVerticalPadding)
        
    }
 
    /* view components */
    
    // Log Row
    private func logRow(for entry: WeightEntryModel) -> some View {
        
        HStack {
            
            // Weight Log
            Text("\(entry.weight, specifier: "%.1f") \(viewModel.unitLabel)")

            Spacer()

            // Log Date
            Text(entry.date.formatted(.dateTime.month(.wide).day().weekday(.abbreviated)))
                .foregroundStyle(.secondary)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
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
