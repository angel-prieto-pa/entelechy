//
//  HomeView.swift
//  entelechy
//
//  Created by Angel Prieto on 11/28/25.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    private enum ActiveOverlay {
        case history
        case progress
    }
    
    /* variables */

    @StateObject private var viewModel: LogEntryViewModel
    @State private var activeOverlay: ActiveOverlay?
    
    /* init */

    init(context: NSManagedObjectContext) {
        // View Model relies on persistence container context to mangae data.
        _viewModel = StateObject(wrappedValue: LogEntryViewModel(context: context))
    }
    
    /* body */

    var body: some View {
        
        ZStack {
            VStack {
                
                // App Title
                AppTitleText()

                // Log
                LogEntryView(viewModel: viewModel)
                    .padding(.horizontal, AppLayout.contentHorizontalInset)

                // Buttons
                self.floatingButtons
                
            }

            // Overlay Vies
            if let activeOverlay {
                overlayView(for: activeOverlay)
                    .zIndex(1)
            }
            
        }
//        .animation(.easeInOut(duration: 0.25), value: activeOverlay)
        
    }

    private var floatingButtons: some View {
            
        HStack {
                
            // History
            CircleButton(
                image: Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90"),
                action: { present(.history) }
            )

            Spacer()
                
            // Progress
            CircleButton(
                image: Image(systemName: "chart.line.uptrend.xyaxis"),
                action: { present(.progress) }
            )
        }
        .padding(.horizontal, AppLayout.floatingButtonInset)
        
    }

    @ViewBuilder
    private func overlayView(for overlay: ActiveOverlay) -> some View {
        switch overlay {
        case .history:
            HistoryView(viewModel: viewModel, onClose: dismissOverlay)
                .transition(.move(edge: .leading).combined(with: .opacity))
        case .progress:
            ProgressView(onClose: dismissOverlay)
                .transition(.move(edge: .trailing).combined(with: .opacity))
        }
    }

    private func present(_ overlay: ActiveOverlay) {
        withAnimation(.easeInOut(duration: 0.25)) {
            activeOverlay = overlay
        }
    }

    private func dismissOverlay() {
        withAnimation(.easeInOut(duration: 0.25)) {
            activeOverlay = nil
        }
    }
}


#Preview {
    HomeView(context: PersistenceController.shared.container.viewContext)
}
