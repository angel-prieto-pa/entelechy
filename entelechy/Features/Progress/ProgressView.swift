//
//  ProgressView.swift
//  entelechy
//
//  Created by Angel Prieto on 4/12/26.
//

import SwiftUI

struct ProgressView: View {
    
    /* structs */
    
    enum ProgressTabs {
        case summary
        case chart
    }
    
    /* varibales */
    
    @State private var selectedTab: ProgressTabs = .summary
    
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
            ZStack {
                Group {
                    
                    switch selectedTab {
                    case .summary:
                        ProgressSummaryView()
                            .padding(.horizontal, AppLayout.contentHorizontalInset)
                    case .chart:
                        ProgressChartView()
                            .padding(.horizontal, AppLayout.contentHorizontalInset)
                    }
                    
                }
                
            }

            Spacer()

            // Tab Bar
            TabBarView(selectedTab: $selectedTab, tabItems: [
                TabBarItem<ProgressTabs>(title: "Summary", systemImage: "text.page", tab: .summary),
                TabBarItem<ProgressTabs>(title: "Chart", systemImage: "chart.bar.xaxis", tab: .chart)
            ])
            
        }
        .background(Color(.systemBackground))
        
    }
}

