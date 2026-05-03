//
//  HistoryLogView.swift
//  entelechy
//
//  Created by Angel Prieto on 03/15/26.
//

import SwiftUI

struct HistoryLogView: View {
    
    /* variables */

    @ObservedObject private var viewModel: HistoryViewModel
    
    @ScaledMetric(relativeTo: .body) private var contentPadding: CGFloat = 10.0
    @ScaledMetric(relativeTo: .body) private var subcontentSpacing: CGFloat = 5.0
    @ScaledMetric(relativeTo: .body) private var scrollViewVerticalPadding: CGFloat = AppLayout.contentVerticalPadding
    
    private let displayCornerRadius: CGFloat = 30.0
    private let contentOutlineWidth: CGFloat = 1.5
    
    private var scrollViewHorizontalPadding: CGFloat {
        self.contentPadding + AppLayout.contentOutlineWidth
    }
    
    /* init */
    
    init(viewModel: HistoryViewModel) {
        self.viewModel = viewModel
    }
    
    /* body */

    var body: some View {
        
        VStack {
            
            ScrollView {
                
                LazyVStack(alignment: .leading, spacing: 0.0, pinnedViews: [.sectionHeaders]) {
                    
                    ForEach(viewModel.weightYearsEnumerated, id: \.element.id) { index, weightYear in
                        self.yearSection(
                            weightYear: weightYear,
                            isLastYear: index == self.viewModel.weightYearsEnumerated.count - 1
                        )
                    }
                }
                
            }
            .scrollIndicators(.hidden)
            .padding(.bottom, 15)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(AppColors.accent),
                alignment: .bottom
            )
            
            Spacer()
                .frame(maxHeight: 20.0)
            
        }
        
    }
 
    /* view components */

    // Year Section
    @ViewBuilder
    private func yearSection(weightYear: WeightYearModel, isLastYear: Bool) -> some View {
        
        Section {
            
            self.yearSectionContent(for: weightYear, isLastYear: isLastYear)
            
        } header: {
            
            self.yearHeader(for: weightYear.year)
                .font(.subheadline.weight(.bold))
                .padding(AppLayout.contentOutlineWidth)
                .padding(.bottom, 10)
                .background(.background)
                
            
        }
    }

    // Year Section Content
    private func yearSectionContent(for weightYear: WeightYearModel, isLastYear: Bool) -> some View {
        ForEach(Array(weightYear.weeks.enumerated()), id: \.element.id) { index, weightWeek in
            self.weekContent(
                for: weightWeek,
                isLast: index == weightYear.weeks.count - 1 && !isLastYear
            )
        }
        .padding(.horizontal, self.scrollViewHorizontalPadding)
        .padding(.vertical, self.scrollViewVerticalPadding)
    }

    // Week Content
    private func weekContent(for weightWeek: WeightWeekModel, isLast: Bool) -> some View {
        
        VStack(alignment: .leading, spacing: self.subcontentSpacing) {
            
            self.weekHeader(for: weightWeek.week)

            ForEach(weightWeek.logs) { log in
                self.logRow(for: log)
            }
            .padding(.horizontal, self.contentPadding)
        }
        .padding(.top, self.scrollViewVerticalPadding)
        .padding(.bottom, isLast ? 20.0 : self.scrollViewVerticalPadding)
        
    }

    // Week Header
    private func weekHeader(for week: Int) -> some View {
        Text("Week \(week)")
            .font(.subheadline.weight(.medium))
            .foregroundStyle(.secondary)
            .underline()
    }
    
    // Log Row
    private func logRow(for entry: WeightEntryModel) -> some View {
        
        HStack {
            
            // Weight Log
            Text("\(entry.weight, specifier: "%.1f") \(AppInfo.unitLabel)")

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
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(AppColors.accent),
                    alignment: .top
                )
            .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(AppColors.accent),
                    alignment: .bottom
                )
            
            
            
    }
    
}
