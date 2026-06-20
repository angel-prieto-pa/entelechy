//
//  PersistenceErrorView.swift
//  entelechy
//
//  Created by Angel Prieto on 6/19/26.
//

import SwiftUI

struct PersistenceErrorView: View {
    
    /* variables */
    
    let error: Error
    
    @ScaledMetric(relativeTo: .body) private var contentSpacing: CGFloat = 3.0 * AppLayout.contentVerticalPadding
    
    /* body */
    
    var body: some View {
        
        VStack(alignment: .center, spacing: self.contentSpacing) {
            
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50.0, weight: .semibold))
                .foregroundStyle(AppColors.accent)
            
            Text("Unable to Load Data")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary)
            
            Text("Please restart the app.")
                .font(.subheadline.weight(.regular))
                .foregroundStyle(.secondary)
                .italic()
                .multilineTextAlignment(.center)
                .padding(.horizontal, self.contentSpacing)
            
            Text("If the issue continues, reinstalling may be required.")
                .font(.subheadline.weight(.regular))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, self.contentSpacing)
            
            #if DEBUG
            Text(self.error.localizedDescription)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            #endif
            
        }
        .padding(2.0 * self.contentSpacing)
        
    }
    
}
