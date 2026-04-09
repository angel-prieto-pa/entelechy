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
    
    let onClose: () -> Void

    @State private var selectedTab: Tab = .calendar

    var body: some View {
        
        VStack() {
            
            // Header
            ZStack {
                
                // App Title Space
                AppTitleText(display: false)
                
                // Back Button
                HStack {
                    
                    Spacer()

                    CircleButton(
                        image: Image(systemName: "chevron.forward"),
                        action: { onClose() }
                    )
                    
                }
                .padding(.horizontal, AppLayout.floatingButtonInset)
                
            }

            // Title
            PageTitleText(title: "History")
            
            Spacer()
                .frame(maxHeight: AppLayout.titleSpacer)

            // Appropriate View
            ZStack {
                Group {
                    
                    switch selectedTab {
                    case .calendar:
                        HistoryCalendarView(viewModel: viewModel)
                    case .entries:
                        HistoryLogView(viewModel: viewModel)
                    }
                    
                }
            }
//            .animation(.easeInOut(duration: 0.25), value: selectedTab)
//            .padding()

            Spacer()

            // Tab Bar
            HistoryTabBarView(selectedTab: $selectedTab)
            
        }
//        .padding()
        .background(Color(.systemBackground))
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
