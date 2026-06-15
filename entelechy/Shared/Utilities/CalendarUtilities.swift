//
//  CalendarUtilities.swift
//  entelechy
//
//  Created by Angel Prieto on 6/8/26.
//

import Foundation

struct CalendarUtilities {
    
    /* variables*/
    
    private let calendar: Calendar
    private let referenceDate: Date
    
    /* init */

    init(calendar: Calendar = .current, referenceDate: Date = Date()) {
        self.calendar = calendar
        self.referenceDate = Calendar.current.startOfDay(for: referenceDate)
    }

    /* public functions */
    
    func currentDate() -> Date {
        return self.referenceDate
    }
    
    // Date
    func date(byAdding component: Calendar.Component, amount: Int, to date: Date) -> Date {
        
        guard let offsetDate = self.calendar.date(byAdding: component, value: amount, to: date) else {
            return date
        }
        
        return offsetDate
        
    }
    
    // Start Date
    func startDate(of component: Calendar.Component, for date: Date) -> Date {
        
        guard let start = self.calendar.dateInterval(of: component, for: date)?.start else {
            return date
        }
        
        return start
        
    }
    
    // Month
    func month(for date: Date? = nil) -> Int {
        self.calendar.component(.month, from: date ?? self.referenceDate)
    }

    // Month Bounds
    func monthBounds(for date: Date? = nil) -> ClosedRange<Date> {
        
        let interval = self.monthInterval(for: date ?? self.referenceDate)
        
        let monthStart = interval.start
        let monthEnd = self.date(byAdding: .day, amount: -1, to: interval.end)
        
        return monthStart...monthEnd
        
    }
    
    // Count
    func count(of component: Calendar.Component, from start: Date, to end: Date) -> Int {
        
        guard let range = self.calendar.dateComponents([component], from: start, to: end).value(for: component) else {
            return 0
        }
        
        return range
    }
    
    /* private functions */
    
    private func monthInterval(for date: Date) -> DateInterval {
        
        guard let interval = self.calendar.dateInterval(of: .month, for: date) else {
            return DateInterval(start: date, end: date)
        }
        
        return interval
        
    }
    
}
