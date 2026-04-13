//
//  ProgressView.swift
//  entelechy
//
//  Created by Angel Prieto on 4/12/26.
//

import SwiftUI

struct ProgressView: View {
    
    enum Tab {
        case summary
        case chart
    }
    
    /* varibales */
    
//    @State private var selectedTab: Tab = .summary
    
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

                    CircleButton(
                        image: Image(systemName: "chevron.backward"),
                        action: { self.onClose() }
                    )
                    
                    Spacer()
                    
                }
                .padding(.horizontal, AppLayout.floatingButtonInset)
                
            }

            // Title
            PageTitleText(title: "Progress")
            
            Spacer()
                .frame(maxHeight: AppLayout.titleSpacer)

            // Appropriate View
//            ZStack {
//                Group {
//                    
//                    switch selectedTab {
//                    case .calendar:
//                        HistoryCalendarView(viewModel: viewModel)
//                            .padding(.horizontal, AppLayout.contentHorizontalInset)
//                    case .entries:
//                        HistoryLogView(viewModel: viewModel)
//                    }
//                    
//                }
//            }

            Spacer()

            // Tab Bar
//            HistoryTabBarView(selectedTab: $selectedTab)
            
        }
        .background(Color(.systemBackground))
        
    }
}

