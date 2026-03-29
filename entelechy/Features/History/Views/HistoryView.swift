//
//  HistoryView.swift
//  entelechy
//
//  Created by Angel Prieto on 03/15/26.
//

import SwiftUI
import CoreData

struct HistoryView: View {
    
    enum Tab {
        case calendar
        case entries
    }

    @ObservedObject var viewModel: LogEntryViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedTab: Tab = .calendar

    var body: some View {
        
        VStack(spacing: AppLayout.pageSpacing) {
            
            HStack {
                
                // Exit Button
                Button(action: { dismiss() }) {
                    
                    Circle()
                        .fill(AppColors.floatingButtonBackground)
                        .frame(width: AppLayout.floatingButtonSize, height: AppLayout.floatingButtonSize)
                        .shadow(
                            color: AppColors.inputShadow,
                            radius: AppLayout.floatingButtonShadowRadius,
                            x: 0,
                            y: AppLayout.floatingButtonShadowYOffset
                        )
                        .overlay(
                            Image(systemName: "chevron.left")
                                .foregroundColor(AppColors.accent)
                                .font(.system(size: 18, weight: .semibold))
                        )
                }

                Spacer()
                
            }

            // Title
            PageTitleText(title: "History")
                .padding(.top, AppLayout.titleTopPadding)

            // View with Tab Bar
            Group {
                
                switch selectedTab {
                case .calendar:
                    HistoryCalendarView(viewModel: viewModel)
                case .entries:
                    HistoryLogView(viewModel: viewModel)
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.systemBackground))
        .safeAreaInset(edge: .bottom) {
            HistoryTabBarView(selectedTab: $selectedTab)
        }
        
    }
}

private struct HistoryTabBarView: View {
    
    @Binding var selectedTab: HistoryView.Tab

    var body: some View {
        
        // Tab Bar
        HStack(spacing: 0) {
            tabButton(title: "Calendar", systemImage: "calendar", tab: .calendar)
            tabButton(title: "Entries", systemImage: "list.bullet", tab: .entries)
        }
        .padding(2)
        .background(
            Capsule()
                .fill(Color(.secondarySystemBackground))
        )
        .padding(.horizontal, AppLayout.floatingButtonInset)
        .padding(.top, 8)
        .padding(.bottom, 8)
        .animation(nil, value: selectedTab)
    }

    private func tabButton(title: String, systemImage: String, tab: HistoryView.Tab) -> some View {
        
        let isSelected = selectedTab == tab

        // Tab Bar Button
        return Button(action: { selectedTab = tab }) {
            
            HStack(spacing: 10) {
                Image(systemName: systemImage)
                    .font(.system(size: 20, weight: .medium))

                Text(title)
                    .font(.body.weight(.medium))
            }
            .foregroundStyle(isSelected ? AppColors.accent : .secondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background {
                Capsule()
                    .fill(isSelected ? Color(.systemBackground) : Color(.secondarySystemBackground))
            }
        }
        .buttonStyle(.plain)
        
    }
}
