//
//  HistoryView.swift
//  entelechy
//
//  Created by Angel Prieto on 03/15/26.
//

import SwiftUI

struct HistoryView: View {
    
    /* structs */
    
    enum HistoryTabs {
        case calendar
        case entries
    }
    
    /* varibales */

    @ObservedObject private var viewModel: HistoryViewModel
    private let onClose: () -> Void
    
    @State private var selectedTab: HistoryTabs = .calendar
    
    /* init */
    
    init(viewModel: HistoryViewModel, onClose: @escaping ()-> Void) {
        self.viewModel = viewModel
        self.onClose = onClose
    }
    
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
                        HistoryCalendarView(viewModel: self.viewModel)
                            .padding(.horizontal, AppLayout.contentHorizontalInset)
                    case .entries:
                        HistoryLogView(viewModel: self.viewModel)
                            .padding(.horizontal, AppLayout.contentHorizontalInset)
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
