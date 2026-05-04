//
//  ProgressSummaryView.swift
//  entelechy
//
//  Created by Angel Prieto on 4/25/26.
//

import SwiftUI

struct ProgressSummaryView: View {
    
    /* variables */
    
    @ObservedObject private var viewModel: ProgressViewModel
    
    @ScaledMetric(relativeTo: .body) private var scrollViewVerticalPadding: CGFloat = 3.0 * AppLayout.contentVerticalPadding
    
    @ScaledMetric(relativeTo: .body) private var contentSpacing: CGFloat = 2.0 * AppLayout.contentVerticalPadding
    @ScaledMetric(relativeTo: .body) private var subcontentSpacing: CGFloat = AppLayout.contentVerticalPadding
    
    private let bottomSpacerHeight: CGFloat = 20.0
    
    /* init */
    
    init(viewModel: ProgressViewModel) {
        self.viewModel = viewModel
    }
    
    /* body */

    var body: some View {
        
        let averageYears = viewModel.averageYearsEnumerated
        
        return VStack {
            
            ScrollView {
                
                LazyVStack(alignment: .leading, spacing: 0.0, pinnedViews: [.sectionHeaders]) {
                    
                    ForEach(averageYears, id: \.element.id) { index, weightYear in
                        self.yearSection(
                            weightYear: weightYear,
                            isLastYear: index == averageYears.count - 1
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
    private func yearSection(weightYear: WeightAverageYearModel, isLastYear: Bool) -> some View {
        
        Section {
            
            self.yearSectionContent(for: weightYear, isLastYear: isLastYear)
                .padding(.horizontal, 2.0 * self.contentSpacing)
            
        } header: {
            
            self.yearHeader(for: weightYear.year)
                .padding(.bottom, self.scrollViewVerticalPadding)
                .background(.background)
            
        }
    }

    // Year Section Content
    private func yearSectionContent(for weightYear: WeightAverageYearModel, isLastYear: Bool) -> some View {
        
        ForEach(Array(weightYear.weeks.enumerated()), id: \.element.id) { index, weightWeek in
            
            self.weekContent(
                for: weightWeek,
                isLast: index == weightYear.weeks.count - 1 && !isLastYear
            )
            
        }
        
    }

    // Week Content
    private func weekContent(for weightWeek: WeightAverageWeekModel, isLast: Bool) -> some View {
        
        self.averageRow(for: weightWeek)
            .padding(.top, self.subcontentSpacing)
            .padding(.bottom, isLast ? 2.0 * self.contentSpacing : self.contentSpacing)
        
    }
    
    // Average Row
    private func averageRow(for weightWeek: WeightAverageWeekModel) -> some View {
        
        let week = weightWeek.week
        let average = weightWeek.average
        let modifier = viewModel.differenceModifier(for: weightWeek)
        let difference = abs(weightWeek.difference)
        let color = viewModel.accentColor(for: weightWeek)
        
        return HStack {
            
            VStack(alignment: .leading, spacing: 2.0) {
                Text("Week \(week)")
                    .font(.body.weight(.regular))
                    .foregroundStyle(.primary)
                
                Text("Average: \(average, specifier: "%.1f") \(AppInfo.unitLabel)")
                    .font(.subheadline.weight(.regular))
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: self.contentSpacing)

            Text("\(modifier)\(difference, specifier: "%.1f")")
                .font(.body.weight(.bold))
                .foregroundStyle(color)
                .frame(maxWidth: 55.0)
                .padding(.vertical, self.subcontentSpacing)
                .overlay(
                    RoundedRectangle(cornerRadius: 30.0, style: .continuous)
                        .fill(color)
                        .opacity(0.15)
                )
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
