//
//  HistoryCalendarView.swift
//  entelechy
//
//  Created by Angel Prieto on 03/12/26.
//

import SwiftUI

struct HistoryCalendarView: View {
    
    /* variables */
    
    @ObservedObject private var viewModel: HistoryViewModel
    
    @State private var displayedMonth: Date = Date()
    @State private var selectedDate: Date? = nil
    
    private let calendar = Calendar.current
    
    @ScaledMetric(relativeTo: .body) private var daySize: CGFloat = AppLayout.calendarDaySize
    @ScaledMetric(relativeTo: .title3) private var chevronFontSize: CGFloat = 20.0
    
    /* init */
    
    init(viewModel: HistoryViewModel) {
        self.viewModel = viewModel
    }
    
    /* body */

    var body: some View {
        
        VStack {
            
            // Calendar Header
            self.header
            // Calendar Days
            self.calendarDays
                .padding(.vertical, AppLayout.contentVerticalPadding)
            // Calendar Grid
            self.calendarGrid
                .padding(.vertical, AppLayout.contentVerticalPadding)
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
            
            Spacer()
            
            // Log Details
            self.entryDetails

            Spacer()
            
        }
        .compositingGroup()
        
    }
    
    /* helper variables */
    
    private var calendarGridRows: [[Date?]] {
        /* Provides array of Optional Date objects for the days of the displayed month, including its leading blank days and empty weeks. */
        
        // Array of days in a month including leading blank days.
        let cells = Array(repeating: Optional<Date>.none, count: self.leadingBlankDays(self.displayedMonth)) + self.daysInMonth(self.displayedMonth).map(Optional.some)
        
        // Rows of days, each of length 7.
        let rows = stride(from: 0, to: cells.count, by: 7).map { index in
            let endIndex = min(index + 7, cells.count)
            let row = Array(cells[index..<endIndex])
            return row + Array(repeating: nil, count: max(0, 7 - row.count))
        }
        
        // Ensures 6 rows of weeks.
        return rows + Array(repeating: Array(repeating: nil, count: 7), count: max(0, 6 - rows.count))
        
    }
    
    /* helper functions */
    
    private var monthTitle: String {
        /* Computes and returns the displayed month as a string. */
        self.displayedMonth.formatted(.dateTime.month(.wide).year())
    }
    
    private func daysInMonth(_ date: Date) -> [Date] {
        /* Returns array of dates in the month of the provided date. */
        
        guard let monthInterval: DateInterval = self.calendar.dateInterval(of: .month, for: date) else { return [] }
        
        var dates: [Date] = []
        
        var current = monthInterval.start
        while current < monthInterval.end {
            dates.append(current)
            current = self.calendar.date(byAdding: .day, value: 1, to: current) ?? current
        }
        
        return dates
        
    }
    
    private func leadingBlankDays(_ date: Date) -> Int {
        /* Returns leading blank days for first week of the month, based on the day of the week the month starts on. */
        
        guard let monthStart: Date = self.calendar.dateInterval(of: .month, for: date)?.start else { return 0 }
        
        let weekday: Int = self.calendar.component(.weekday, from: monthStart)
        
        return (weekday - self.calendar.firstWeekday + 7) % 7
        
    }

    private func isSelected(on date: Date) -> Bool {
        /* Returns whether the date provided is currently selected. */
        
        guard let selectedDate else { return false }
        return self.calendar.isDate(selectedDate, inSameDayAs: date)
    }
    
    
    /* view components */

    // Calendar Header
    private var header: some View {
        
        Grid(horizontalSpacing: 0.0, verticalSpacing: 0.0) {
            GridRow {
                
                // Left Arrow
                Button(action: { displayedMonth = self.calendar.date(byAdding: .month, value: -1, to: displayedMonth) ?? displayedMonth }) {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(AppColors.accent)
                        .font(.system(size: self.chevronFontSize, weight: .semibold))
                }
                .frame(maxWidth: .infinity)
                
                // Month
                Text(monthTitle)
                    .font(.title3.weight(.semibold))
                    .lineLimit(1)
                    .gridCellColumns(5)
                    .frame(maxWidth: .infinity)
                
                // Right Arrow
                Button(action: { displayedMonth = self.calendar.date(byAdding: .month, value: 1, to: displayedMonth) ?? displayedMonth })
                {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(AppColors.accent)
                        .font(.system(size: self.chevronFontSize, weight: .semibold))
                }
                .frame(maxWidth: .infinity)
                
            }
        }

    }
    
    // Calendar Letter Days
    private var calendarDays: some View {
        
        // Days of the Week
        Grid(horizontalSpacing: 0.0, verticalSpacing: 0.0) {
            GridRow {
                
                // Letter
                ForEach(Array(self.calendar.veryShortWeekdaySymbols.enumerated()), id: \.offset) { _, symbol in
                    Text(symbol.uppercased())
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                
            }
        }
        
    }

    // Calendar Grid
    private var calendarGrid: some View {
            
        // Day Grid
        Grid(horizontalSpacing: 0.0, verticalSpacing: 0.0) {
            
            ForEach(Array(self.calendarGridRows.enumerated()), id: \.offset) { _, row in
                
                Group {
                    GridRow {
                        
                        ForEach(Array(row.enumerated()), id: \.offset) { _, cell in
                            
                            // Calendar Day
                            Group {
                                if let date = cell {
                                    self.calendarDayButton(for: date)
                                } else {
                                    Image(systemName: "circle.fill")
                                        .font(.system(size: 2.5, weight: .medium))
                                        .foregroundStyle(.secondary)
                                        .frame(width: self.daySize, height: self.daySize)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            
                        }
                    }
                    .frame(maxHeight: .infinity)
                }
                        
            }
            
        }
        .aspectRatio(1, contentMode: .fit)
        
    }

    // Log Details
    private var entryDetails: some View {
        
        Group {
            
            if let date = self.selectedDate {
                
                if let weight = self.viewModel.weight(on: date) {
                    
                    VStack(spacing: AppLayout.contentVerticalPadding) {
                        Text(date.formatted(.dateTime.weekday(.wide).month(.wide).day()))
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.secondary)
                        
                        
                        Text("\(weight, specifier: "%.1f") \(AppInfo.unitLabel)")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.primary)
                    }
                    .frame(maxWidth: .infinity)
                    
                } else {
                    
                    Text("No log recorded.")
                        .font(.body.italic())
                        .foregroundStyle(.secondary)
                    
                }
            }
            
        }
    }

    // Calendar Day
    private func calendarDayButton(for date: Date) -> some View {
        
        let hasEntry: Bool = self.viewModel.hasEntry(on: date)
        let isSelected: Bool = self.isSelected(on: date)
        let isToday: Bool = self.calendar.isDateInToday(date)

        return Button(action: { self.selectedDate = date }) {
            VStack {
                Text("\(self.calendar.component(.day, from: date))")
                    .font(.title3.weight(isToday ? .bold : .medium))
                    .scaleEffect(isToday ? 1.05 : 1.0)
                    .foregroundStyle(hasEntry && !isSelected ? .white : .primary)
                    .frame(width: self.daySize, height: self.daySize)
                    .background(
                        Circle()
                            .fill(hasEntry && !isSelected ? AppColors.accent : Color.clear)
                    )
                    .overlay(
                        Circle()
                            .stroke(isSelected ? AppColors.accent : Color.clear, lineWidth: AppLayout.calendarDayStrokeWidth)
                    )
            }
        }
        .buttonStyle(.plain)
        
    }
}
