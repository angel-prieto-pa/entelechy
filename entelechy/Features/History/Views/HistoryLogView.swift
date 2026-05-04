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
    
    @ScaledMetric(relativeTo: .body) private var scrollViewVerticalPadding: CGFloat = 3.0 * AppLayout.contentVerticalPadding
    
    @ScaledMetric(relativeTo: .body) private var contentSpacing: CGFloat = 2.0 * AppLayout.contentVerticalPadding
    @ScaledMetric(relativeTo: .body) private var subcontentSpacing: CGFloat = AppLayout.contentVerticalPadding
    
    private let bottomSpacerHeight: CGFloat = 20.0
    
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
            .padding(.bottom, self.scrollViewVerticalPadding)
            .overlay(
                Rectangle()
                    .frame(height: AppLayout.contentOutlineHeight)
                    .foregroundStyle(AppColors.accent),
                alignment: .bottom
            )
            
            Spacer()
                .frame(maxHeight: self.bottomSpacerHeight)
            
        }
        
    }
 
    /* view components */

    // Year Section
    @ViewBuilder
    private func yearSection(weightYear: WeightYearModel, isLastYear: Bool) -> some View {
        
        Section {
            
            self.yearSectionContent(for: weightYear, isLastYear: isLastYear)
                .padding(.horizontal, self.contentSpacing)
            
        } header: {
            
            self.yearHeader(for: weightYear.year)
                .padding(.bottom, self.scrollViewVerticalPadding)
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
        
    }

    // Week Content
    private func weekContent(for weightWeek: WeightWeekModel, isLast: Bool) -> some View {
        
        VStack(alignment: .leading, spacing: self.subcontentSpacing) {
            
            self.weekHeader(for: weightWeek.week)

            ForEach(weightWeek.logs) { log in
                self.logRow(for: log)
            }
            .padding(.horizontal, self.contentSpacing)
            
        }
        .padding(.top, self.subcontentSpacing)
        .padding(.bottom, isLast ? 2.0 * self.contentSpacing : self.contentSpacing)
        
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
            .padding(self.contentSpacing)
            .overlay(
                    Rectangle()
                        .frame(height: AppLayout.contentOutlineHeight)
                        .foregroundStyle(AppColors.accent),
                    alignment: .top
                )
            .overlay(
                    Rectangle()
                        .frame(height: AppLayout.contentOutlineHeight)
                        .foregroundStyle(AppColors.accent),
                    alignment: .bottom
                )
            
    }
    
}
