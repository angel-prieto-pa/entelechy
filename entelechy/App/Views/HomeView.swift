//
//  HomeView.swift
//  entelechy
//
//  Created by Angel Prieto on 11/28/25.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    /* structures */
    
    private enum ActiveOverlay {
        case history
        case progress
    }
    
    /* variables */

    @State private var activeOverlay: ActiveOverlay?
    
    @StateObject private var repository: WeightEntryRepository
    
    private var logEntryViewModel: LogEntryViewModel
    @StateObject private var historyViewModel: HistoryViewModel
    @StateObject private var progressViewModel: ProgressViewModel
    
    let context: NSManagedObjectContext
    
    /* init */

    init(context: NSManagedObjectContext) {
        // View Model relies on persistence container context to mangae data.
        self.context = context
        
        let repository = WeightEntryRepository(context: context)
        _repository = StateObject(wrappedValue: repository)
        
        self.logEntryViewModel = LogEntryViewModel(repository: repository)
        _historyViewModel = StateObject(wrappedValue: HistoryViewModel(repository: repository))
        _progressViewModel = StateObject(wrappedValue: ProgressViewModel(repository: repository))
        
    }
    
    /* body */

    var body: some View {
        
        ZStack {
            VStack {
                
                // App Title
                AppTitleText()

                // Log
                LogEntryView(viewModel: logEntryViewModel)
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
            HistoryView(viewModel: self.historyViewModel, onClose: dismissOverlay)
                .transition(.move(edge: .leading).combined(with: .opacity))
        case .progress:
            ProgressView(viewModel: self.progressViewModel, onClose: dismissOverlay)
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
