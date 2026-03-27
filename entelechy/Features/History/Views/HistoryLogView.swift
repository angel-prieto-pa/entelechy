//
//  HistoryLogView.swift
//  entelechy
//
//  Created by Angel Prieto on 03/15/26.
//


import SwiftUI

struct HistoryLogView: View {
    
    @ObservedObject var viewModel: LogEntryViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: AppLayout.pageSpacing) {
            HistoryHeaderView(onBack: { dismiss() })

            PageTitleText(title: "History")
                .padding(.top, AppLayout.titleTopPadding)

            TabView {
                HistoryCalendarView(viewModel: viewModel)
                    .tabItem {
                        Label("Calendar", systemImage: "calendar")
                    }

                PastEntriesView(viewModel: viewModel)
                    .tabItem {
                        Label("Entries", systemImage: "list.bullet")
                    }
            }
            .tint(AppColors.accent)
        }
        .padding()
    }
}

private struct PastEntriesView: View {
    @ObservedObject var viewModel: LogEntryViewModel

    var body: some View {
        List(viewModel.entryLog.reversed()) { entry in
            HStack {
                Text("\(entry.weight, specifier: "%.1f") \(viewModel.unitLabel)")
                Spacer()
                Text(entry.date, style: .date)
                    .foregroundColor(.secondary)
            }
        }
    }
}

private struct HistoryHeaderView: View {
    let onBack: () -> Void

    var body: some View {
        HStack {
            Button(action: onBack) {
                Circle()
                    .fill(AppColors.floatingButtonBackground)
                    .frame(width: AppLayout.floatingButtonSize, height: AppLayout.floatingButtonSize)
                    .shadow(color: AppColors.inputShadow, radius: AppLayout.floatingButtonShadowRadius, x: 0, y: AppLayout.floatingButtonShadowYOffset)
                    .overlay(
                        Image(systemName: "chevron.left")
                            .foregroundColor(AppColors.accent)
                            .font(.system(size: 18, weight: .semibold))
                    )
            }
            Spacer()
        }
    }
}
