//
//  ProgressChartView.swift
//  entelechy
//
//  Created by Angel Prieto on 4/25/26.
//

import Charts
import SwiftUI

struct ProgressChartView: View {
    
    /* variables */
    
    @ObservedObject private var viewModel: ProgressViewModel
    
    private let calendar = Calendar.current
    
    @ScaledMetric(relativeTo: .body) private var chartHeight: CGFloat = 320.0
    @ScaledMetric(relativeTo: .body) private var contentSpacing: CGFloat = 2.0 * AppLayout.contentVerticalPadding
    @ScaledMetric(relativeTo: .body) private var annotationSpacing: CGFloat = AppLayout.contentVerticalPadding
    
    private let plotAreaColor: Color = AppColors.accent.opacity(0.10)
    private let plotCornerRadius: Double = 15.0
    
    private let chartBackgroundOpacity: Double = 0.5
    
    private let pointSizeEntries: CGFloat = 10.0
    private let pointSizeAverages: CGFloat = 30.0
    private let pointSizeLegend: CGFloat = 10.0
    
    private let pointColorEntries: Color =  AppColors.accent.opacity(0.35)
    private let pointColorAverages: Color =  AppColors.accent
    
    private let lineWidthAverages: CGFloat = 2.5
    
    private let yAxisLabelWidth: CGFloat = 40.0
    
    private let axisStrokeStyleEmphasized: StrokeStyle = StrokeStyle(lineWidth: 1.0)
    
    private let axisPrecision: Decimal.FormatStyle.Configuration.Precision = .fractionLength(1)
    
    /* init */
    
    init(viewModel: ProgressViewModel) {
        self.viewModel = viewModel
    }
    
    /* body */
    
    var body: some View {
        
        let entries = self.viewModel.chartEntries
        let averages = self.viewModel.chartAverageWeeks
        let isEmpty = entries.isEmpty

        return VStack(alignment: .leading) {
            
            ZStack {
                
                // Chart
                self.chart(entries: entries, averages: averages, isEmptyChart: isEmpty)
                    .padding(.bottom, 2.0 * self.contentSpacing)
                
                // Overlapping Empty State
                if isEmpty {
                    self.emptyState
                        .padding(.horizontal, 4.0 * self.contentSpacing)
                }
                
            }
            
            // Range Picker
            self.rangePicker
                .padding(.bottom, self.contentSpacing)
            
            
            // Legend
            if !isEmpty {
                Spacer()
                self.legend
                Spacer()
            }
                
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        
    }
    
    /* view components */
    
    // Picker
    private var rangePicker: some View {
        
        Picker("Chart Range", selection: self.$viewModel.selectedPlotTimeRange) {
            ForEach(ProgressViewModel.PlotTimeRange.allCases) { plotRange in
                Text(plotRange.title)
                    .tag(plotRange)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal, self.contentSpacing)
        
    }
    
    // Chart
    private func chart(entries: [WeightEntryModel], averages: [WeightAverageWeekModel], isEmptyChart: Bool) -> some View {
        
        let xDomain = self.viewModel.getXAxisDomain()
        let yDomain = self.viewModel.getYAxisDomain()
        
        let xAxisMarkers = self.viewModel.getXAxisMarkers(for: xDomain)
        
        return Chart {
            
            if isEmptyChart {
                
                PointMark(
                    x: .value("Date", Date()),
                    y: .value("Weight", yDomain.lowerBound)
                )
                .opacity(0.0)
                
            } else {
                
                // Entries
                ForEach(entries) { entry in
                    PointMark(
                        x: .value("Date", entry.date),
                        y: .value("Weight", entry.weight)
                    )
                    .foregroundStyle(self.pointColorEntries)
                    .symbolSize(self.pointSizeEntries)
                }
                
                // Averages Line Graph
                ForEach(averages) { week in
                    LineMark(
                        x: .value("Week", week.startOfWeek),
                        y: .value("Average", week.average)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(self.pointColorAverages)
                    .lineStyle(StrokeStyle(lineWidth: self.lineWidthAverages, lineCap: .round, lineJoin: .round))
                }
                
                // Averages Points
                ForEach(averages) { week in
                    PointMark(
                        x: .value("Week", week.startOfWeek),
                        y: .value("Average", week.average)
                    )
                    .foregroundStyle(self.pointColorAverages)
                    .symbol(.circle)
                    .symbolSize(self.pointSizeAverages)
                }
            }
        }
        // Frame
        .frame(height: self.chartHeight)
        // Axis Domains
        .chartXScale(domain: xDomain)
        .chartYScale(domain: yDomain)
        // Axis Content
        .chartYAxis {
            self.yAxisMarks(isHidden: isEmptyChart)
        }
        .chartXAxis {
            self.xAxisMarks(from: xAxisMarkers, isHidden: isEmptyChart)
        }
        // Chart Plot Style
        .chartPlotStyle { plotArea in
            plotArea
                .background(self.plotAreaColor)
                .clipShape(RoundedRectangle(cornerRadius: self.plotCornerRadius, style: .continuous))
                .padding(.bottom, 0.5 * self.contentSpacing)
        }
        // Chart Background
        .background(.background.opacity(self.chartBackgroundOpacity))
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: self.plotCornerRadius, style: .continuous))
        
    }
    
    // Legend
    private var legend: some View {
        
        HStack {
            self.legendItem(color: self.pointColorEntries, title: "Entries", subtitle: "Individual Weight")
                .frame(maxWidth: .infinity)
            
            self.legendItem(color: self.pointColorAverages, title: "Average", subtitle: "Weekly Trend")
                .frame(maxWidth: .infinity)
        }
        
    }
    
    // Legend Items
    private func legendItem(color: Color, title: String, subtitle: String) -> some View {
        
        HStack(spacing: self.contentSpacing) {
            
            // Data Color
            Circle()
                .fill(color)
                .frame(width: self.pointSizeLegend, height: self.pointSizeLegend)
            
            // Title and Subtitle
            VStack(alignment: .leading, spacing: self.annotationSpacing) {
                
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                
                Text(subtitle)
                    .font(.caption.weight(.regular))
                    .foregroundStyle(.secondary)
                
            }
            
        }
        
    }
    
    // Empty State
    private var emptyState: some View {
        
        VStack(alignment: .center, spacing: self.contentSpacing) {
            Text("No chart data available.")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary)
            
            Text("Log a few weights to see entries and weekly averages over time.")
                .font(.subheadline.weight(.regular))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, self.contentSpacing)
        }
        
    }
    
    // Y-Axis Marks
    private func yAxisMarks(isHidden: Bool) -> some AxisContent {
        
        return AxisMarks(position: .leading) { value in
            
            // Grid Line and Axis Tick.
            if isHidden {
                AxisGridLine()
                    .foregroundStyle(.clear)
                AxisTick()
                    .foregroundStyle(.clear)
            } else {
                AxisGridLine()
                AxisTick()
            }
            
            // Axis Label
            AxisValueLabel(horizontalSpacing: 0.0) {
                
                if let weight = value.as(Double.self) {
                    Text(weight, format: .number.precision(self.axisPrecision))
                        .frame(width: self.yAxisLabelWidth, alignment: .center)
                        .opacity(isHidden ? 0.0 : 1.0)
                }
                
            }

        }
    }
    
    // X-Axis Marks
    private func xAxisMarks(from dates: [Date], isHidden: Bool) -> some AxisContent {
        
        let today: Date = self.calendar.startOfDay(for: Date())
        
        /* Determine the tick increments based on the amount of total months, from monthly, bi-monthly, and quarterly. */
        
        let isTodayFirst: Bool = (self.calendar.component(.day, from: today) == 1)
        
        let tickIncrement: Int
        
        // Month count, based on dates excluding edge month and current day.
        let monthCount: Int = dates.count - 1 - (isTodayFirst ? 1 : 0)
        
        if monthCount < 6 {
            // Monthly.
            tickIncrement = 1
        } else if monthCount < 8 {
            // Bi-Monthly.
            tickIncrement = 2
        } else {
            // Quarterly.
            tickIncrement = 3
        }
        
        return AxisMarks(values: dates) { value in
            
            // Add style depending on the month or if is hidden.
            if let date = value.as(Date.self) {
                
                let month = self.calendar.component(.month, from: date)
                
                if isHidden {
                    // Hide label to provide padding for chart.
                    
                    AxisValueLabel(verticalSpacing: 0.5 * self.contentSpacing) {
                        self.xAxisLabelText(for: date, isHidden: true)
                    }
                    
//                } else if date == today {
//                    
//                    AxisGridLine(stroke: self.axisStrokeStyleEmphasized)
//                        .foregroundStyle(AppColors.accent)
//                    
//                    if isTodayFirst {
//                        
//                        AxisTick(stroke: self.axisStrokeStyleEmphasized)
//                            .foregroundStyle(AppColors.accent)
//                    }
                    
                } else if month == 1 {
                    // Add bold grid line, tick, and label for first of the year.
                    
                    AxisGridLine(stroke: self.axisStrokeStyleEmphasized)
                    
                    AxisTick(stroke: self.axisStrokeStyleEmphasized)
                    
                    AxisValueLabel(verticalSpacing: 0.5 * self.contentSpacing) {
                        self.xAxisLabelText(for: date, isEmphasized: true)
                    }
                    
                } else if (month - 1) % tickIncrement == 0 {
                    // Add grid line, tick, and label to start of month based on increment level.
                    
                    AxisGridLine()
                    
                    AxisTick()
                    
                    AxisValueLabel(verticalSpacing: 0.5 * self.contentSpacing) {
                        self.xAxisLabelText(for: date)
                    }
                    
                } else {
                    // Add grid line for the start of each month.
                    
                    AxisGridLine()
                    
                }
                
            }
        }
        
    }
    
    // X-Axis Label Text
    private func xAxisLabelText(for date: Date, isEmphasized: Bool = false, isHidden: Bool = false) -> some View {
        
        Text(date, format: self.xAxisLabelFormat)
            .fontWeight(isEmphasized ? .medium : .regular)
            .opacity(isHidden ? 0.0 : 1.0)
        
    }
    
    /* helper functions */
    
    private var xAxisLabelFormat: Date.FormatStyle {
        
        // TODO:
        switch self.viewModel.selectedPlotTimeRange {
        case .rangeMonth:
            return .dateTime.month(.abbreviated).day()
        case .rangeThreeMonth, .rangeSixMonth, .rangeYear:
            return .dateTime.month(.abbreviated)
        case .rangeAll:
            return .dateTime.month(.abbreviated)
        }
    }
    
}
