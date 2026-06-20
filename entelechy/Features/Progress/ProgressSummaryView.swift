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
        
        let averageYears = self.viewModel.averageYearsEnumerated
        let isEmpty = self.viewModel.averageYearsEnumerated.isEmpty
        
        return ZStack {
            
            if isEmpty {
                
                VStack {
                    
                    Spacer()
                    
                    EmptyStateView(type: .progressSummary)
                    
                    Spacer()
                    Spacer()
                    
                }
                
            }
            
            VStack {
                
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
            .opacity(isEmpty ? 0.0 : 1.0)
            
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
        let dateRange = self.weekDateRangeText(for: weightWeek)
        let average = weightWeek.average
        let modifier = viewModel.differenceModifier(for: weightWeek)
        let difference = abs(weightWeek.difference)
        let color = viewModel.accentColor(for: weightWeek)
        
        return HStack {
            
            VStack(alignment: .leading, spacing: 2.0) {
                Text("Week \(week)")
                    .font(.body.weight(.regular))
                    .foregroundStyle(.primary)
                
                Text("Dates: \(dateRange)")
                    .font(.footnote.weight(.regular))
                    .foregroundStyle(.secondary)
                
                Text(weekAverageText(for: average))
                    .font(.footnote.weight(.regular))
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
    
    /* helper functions */
    
    private func weekDateRangeText(for weightWeek: WeightAverageWeekModel) -> String {
        /* Computes the end of the week and provides the string of what constitutes a week. */
        
        let calendar = Calendar.current
        let startDate = weightWeek.startOfWeek
        
        let endDate: Date
        
        if let interval = calendar.dateInterval(of: .weekOfYear, for: startDate), let date = calendar.date(byAdding: .day, value: -1, to: interval.end) {
            
            let startYear = calendar.component(.year, from: startDate)
            let endYear = calendar.component(.year, from: date)
            
            let end = calendar.component(.day, from: date)
            
            if startYear != endYear, let endOfYearDate = calendar.date(byAdding: .day, value: (-1 * end), to: date) {
                
                endDate = endOfYearDate

            } else {
                
                endDate = date
            }
            
        } else {
            
            endDate = startDate
            
        }
        
        let formatter = Date.FormatStyle()
            .month(.abbreviated)
            .day()
        
        if startDate == endDate {
            return "\(startDate.formatted(formatter))"
        }
        
        return "\(startDate.formatted(formatter)) - \(endDate.formatted(formatter))"
        
    }
    
    private func weekAverageText(for average: Double) -> AttributedString {
        /* Creates average text for view. */
        
        var text = AttributedString(localized: "Average: ")

        var value = AttributedString(localized: "\(average, specifier: "%.1f") \(AppInfo.unitLabel)")
        value.font = .footnote.weight(.semibold)

        text += value
        
        return text
        
    }
    
}
