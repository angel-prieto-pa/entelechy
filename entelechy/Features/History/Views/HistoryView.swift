//
//  HistoryView.swift
//  entelechy
//
//  Created by Angel Prieto on 03/15/26.
//

import SwiftUI

struct HistoryView: View {
    
    /* varibales */

    @ObservedObject var viewModel: LogEntryViewModel
    
    @State private var selectedTab: HistoryTabs = .calendar
    
    let onClose: () -> Void
    
    /* body */

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
                        action: { self.onClose() }
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
                            .padding(.horizontal, AppLayout.contentHorizontalInset)
                    case .entries:
                        HistoryLogView(viewModel: viewModel)
                            .padding(.horizontal, 1 * AppLayout.contentHorizontalInset)
                    }
                    
                }
                
            }

            Spacer()

            // Tab Bar
            TabBarView(selectedTab: $selectedTab, tabItems: [
                TabBarItem<HistoryTabs>(title: "Calendar", systemImage: "calendar", tab: .calendar),
                TabBarItem<HistoryTabs>(title: "Entries", systemImage: "list.bullet", tab: .entries)
            ])
            
        }
        .background(Color(.systemBackground))
        
    }
}
