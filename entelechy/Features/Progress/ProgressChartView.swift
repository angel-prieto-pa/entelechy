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
    
    @ScaledMetric(relativeTo: .body) private var chartHeight: CGFloat = 320.0
    @ScaledMetric(relativeTo: .body) private var contentSpacing: CGFloat = 2.0 * AppLayout.contentVerticalPadding
    @ScaledMetric(relativeTo: .body) private var annotationSpacing: CGFloat = AppLayout.contentVerticalPadding
    
    private let pointSizeEntries: CGFloat = 10.0
    private let pointSizeAverages: CGFloat = 30.0
    
    private let pointColorEntries: Color =  AppColors.accent.opacity(0.35)
    private let pointColorAverages: Color =  AppColors.accent
    
    private let lineWidthAverages: CGFloat = 2.5
    
    private let plotAreaColor: Color = AppColors.accent.opacity(0.10)
    private let plotCornerRadius: Double = 15.0
    
    private var plotAxisMarks: Int = 4
    
    /* init */
    
    init(viewModel: ProgressViewModel) {
        self.viewModel = viewModel
    }
    
    /* body */
    
    var body: some View {
        
        let entries = self.viewModel.chartEntries
        let averages = self.viewModel.chartAverageWeeks
        
        return VStack(alignment: .leading, spacing: 3.0 * self.contentSpacing) {
            if entries.isEmpty || averages.isEmpty {
                self.emptyState
            } else {
                self.chart(entries: entries, averages: averages)
                self.legend
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        
    }
    
    /* view components */
    
    // Chart
    private func chart(entries: [WeightEntryModel], averages: [WeightAverageWeekModel]) -> some View {
        
        let yDomain = self.weightDomain(entries: entries, averages: averages)
        
        return Chart {
            
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
        .frame(height: self.chartHeight)
        .chartYScale(domain: yDomain)
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: self.plotAxisMarks)) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.month(.abbreviated).day())
            }
        }
        .chartPlotStyle { plotArea in
            plotArea
                .background(self.plotAreaColor)
                .clipShape(RoundedRectangle(cornerRadius: self.plotCornerRadius, style: .continuous))
        }
        
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
                .frame(width: 10.0, height: 10.0)
            
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
        
        VStack(alignment: .leading, spacing: self.contentSpacing) {
            Text("No chart data available.")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary)
            
            Text("Log a few weights to see entries and weekly averages over time.")
                .font(.subheadline.weight(.regular))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        
    }
    
    /* helper functions */
    
    private func weightDomain(entries: [WeightEntryModel], averages: [WeightAverageWeekModel]) -> ClosedRange<Double> {
        /* Returns domain of chart y-axis. */
        
        let weights = entries.map(\.weight) + averages.map(\.average)
        
        guard let minWeight = weights.min(), let maxWeight = weights.max() else {
            return 0.0...0.0
        }
        
        let midpoint = (minWeight + maxWeight) / 2.0
        let weightSpan = (maxWeight - minWeight) * 1.25
        let halfSpan = weightSpan / 2.0
        
        return (midpoint - halfSpan)...(midpoint + halfSpan)
        
    }
    
}
