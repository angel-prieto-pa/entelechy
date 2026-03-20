//
//  HistoryCalendarView.swift
//  entelechy
//
//  Created by Angel Prieto on 03/12/26.
//

import SwiftUI

struct HistoryCalendarView: View {
    
    @ObservedObject var viewModel: LogEntryViewModel
    
    @State private var displayedMonth: Date = Date()
    @State private var selectedDate: Date? = nil

    private let calendar = Calendar.current
    
    @ScaledMetric(relativeTo: .body) private var daySize: CGFloat = AppLayout.calendarDaySize

    var body: some View {
        
        VStack(spacing: AppLayout.pageSpacing) {
            
            // Calendar Header
            header
            // Calendar Grid
            calendarGrid
            
            Spacer()
            
        }
        .padding()
        
    }
    
    private var monthTitle: String {
        /* Computes and returns the displayed month as a string. */
        displayedMonth.formatted(.dateTime.month(.wide).year())
    }

    // Calendar Header
    private var header: some View {
        
        HStack {
            // Left Arrow
            Button(action: { displayedMonth = calendar.date(byAdding: .month, value: -1, to: displayedMonth) ?? displayedMonth }) {
                Image(systemName: "chevron.left")
            }
            
            Spacer()
            
            // Month
            Text(monthTitle)
                .font(.title3.weight(.semibold))
            
            Spacer()
            
            // Right Arrow
            Button(action: { displayedMonth = calendar.date(byAdding: .month, value: 1, to: displayedMonth) ?? displayedMonth }) {
                Image(systemName: "chevron.right")
            }
        }
        
    }

    // Calendar Grid
    private var calendarGrid: some View {
        
        let days: [Date] = daysInMonth(displayedMonth)
        let leadingBlanks: Int = leadingBlankDays(displayedMonth)
        
        return VStack(spacing: AppLayout.calendarRowSpacing) {
            
            // Days of the Week
            HStack {
                ForEach(calendar.veryShortWeekdaySymbols, id: \.self) { symbol in
                    Text(symbol.uppercased())
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.secondary)
                }
            }

            // Calendar Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: AppLayout.calendarGridSpacing) {
                
                // Leading Days / Blank Spaces
                ForEach(0..<leadingBlanks, id: \.self) { _ in
                    Color.clear
                        .frame(height: daySize)
                }

                // Days
                ForEach(days, id: \.self) { date in
                    
                    // Sytles based on whether there is a log for that day and if date is currently selected.
                    // Filled - date is logged. Outlined - date is currently selected (regardless of having a log or not).
                    // Underlined - current day.
                    let hasEntry: Bool = hasEntryOn(date)
                    let isSelected: Bool = isSelectedOn(date)
                    let isToday: Bool = calendar.isDateInToday(date)
                    
                    Button(action: { selectedDate = date }) {
                        VStack(spacing: AppLayout.calendarDayContentSpacing) {
                            Text("\(calendar.component(.day, from: date))")
                                .font(.title3.weight(.semibold))
                                .foregroundStyle(hasEntry && !isSelected ? .white : .primary)
                                .frame(width: daySize, height: daySize)
                                .background(
                                    Circle()
                                        .fill(hasEntry && !isSelected ? AppColors.accent : Color.clear)
                                )
                                .overlay(
                                    Circle()
                                        .stroke(isSelected ? AppColors.accent : Color.clear, lineWidth: AppLayout.calendarDayStrokeWidth)
                                )
                                .overlay(alignment: .bottom) {
                                    if isToday {
                                        Rectangle()
                                            .fill(AppColors.accent)
                                            .frame(width: AppLayout.calendarTodayUnderlineWidth, height: AppLayout.calendarTodayUnderlineHeight)
                                            .cornerRadius(AppLayout.calendarTodayUnderlineHeight / 2)
                                            .offset(y: 6)
                                    }
                                }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                }
                
            }
        }
    }

    private func daysInMonth(_ date: Date) -> [Date] {
        /* Returns array of dates in the month of the provided date. */
        
        guard let monthInterval: DateInterval = calendar.dateInterval(of: .month, for: date) else { return [] }
        
        var dates: [Date] = []
        
        var current = monthInterval.start
        while current < monthInterval.end {
            dates.append(current)
            current = calendar.date(byAdding: .day, value: 1, to: current) ?? current
        }
        
        return dates
    }

    private func leadingBlankDays(_ date: Date) -> Int {
        /* Returns leading blank days for first week of the month, based on the day of the week the month starts on. */
        
        guard let monthStart: Date = calendar.dateInterval(of: .month, for: date)?.start else { return 0 }
        
        let weekday: Int = calendar.component(.weekday, from: monthStart)
        return (weekday - calendar.firstWeekday + 7) % 7
        
    }

    private var loggedDaySet: Set<Date> {
        Set(viewModel.entryLog.map { entry in
            calendar.startOfDay(for: entry.date)
        })
    }

    private func hasEntryOn(_ date: Date) -> Bool {
        /* Returns whether there is a log for date provided. */
        loggedDaySet.contains(calendar.startOfDay(for: date))
    }

    private func isSelectedOn(_ date: Date) -> Bool {
        /* Returns whether the date provided is currently selected. */
        guard let selectedDate else { return false }
        return calendar.isDate(selectedDate, inSameDayAs: date)
    }
}
