//
//  HistoryTabBarView.swift
//  entelechy
//
//  Created by Angel Prieto on 04/07/26.
//

import SwiftUI

struct HistoryTabBarView: View {
    
    /* variables */
    
    @Binding var selectedTab: HistoryView.Tab
    
    @ScaledMetric(relativeTo: .body) private var tabOuterPadding: CGFloat = 2.5
    @ScaledMetric(relativeTo: .body) private var tabInnerImageHeight: CGFloat = 20.0
    @ScaledMetric(relativeTo: .body) private var tabInnerPadding: CGFloat = 15.0

    /* body */
    
    var body: some View {
        
        HStack() {
            self.tabButton(title: "Calendar", systemImage: "calendar", tab: .calendar)
            self.tabButton(title: "Entries", systemImage: "list.bullet", tab: .entries)
        }
        .padding(self.tabOuterPadding)
        .background(
            Capsule()
                .fill(Color(.secondarySystemBackground))
        )
        .padding(.horizontal, AppLayout.floatingButtonInset)
        .animation(nil, value: self.selectedTab)
        
    }
    
    /* view components */

    // Tab Button
    private func tabButton(title: String, systemImage: String, tab: HistoryView.Tab) -> some View {
        /* Buttons for tab view. */
        
        let isSelected = self.selectedTab == tab

        return Button(action: { self.selectedTab = tab }) {
            
            HStack() {
                
                // Tab Button Icon
                Image(systemName: systemImage)
                    .font(.system(size: self.tabInnerImageHeight, weight: .medium))

                // Tab Button Text
                Text(title)
                    .font(.body.weight(.medium))
                
            }
            .foregroundStyle(isSelected ? AppColors.accent : .secondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, self.tabInnerPadding)
            .background {
                Capsule()
                    .fill(isSelected ? Color(.systemBackground) : Color(.secondarySystemBackground))
            }
        }
        .buttonStyle(.plain)
        
    }
    
}
