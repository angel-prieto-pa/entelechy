//
//  CircleButton.swift
//  entelechy
//
//  Created by Angel Prieto on 3/15/26.
//

import SwiftUI

struct CircleButton: View {
    let image: Image
    let action: () -> Void

    var body: some View {
        
        Button(action: action) {
            Circle()
                .fill(Color(.secondarySystemBackground))
                .frame(width: AppLayout.floatingButtonSize, height: AppLayout.floatingButtonSize)
                .overlay(
                    image
                        .foregroundColor(AppColors.accent)
                        .font(.system(size: 20, weight: .semibold))
                )
        }
    }
    
}
