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
    
    /* varibales */

    @ObservedObject var viewModel: LogEntryViewModel
    
    @State private var selectedTab: Tab = .calendar
    
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
                    }
                    
                }
            }

            Spacer()

            // Tab Bar
            HistoryTabBarView(selectedTab: $selectedTab)
            
        }
        .background(Color(.systemBackground))
        
    }
}
