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

    @StateObject private var viewModel: LogEntryViewModel
    @State private var activeOverlay: ActiveOverlay?

    init(context: NSManagedObjectContext) {
        // View Model relies on persistence container context to mangae data.
        _viewModel = StateObject(wrappedValue: LogEntryViewModel(context: context))
    }

    var body: some View {
        ZStack {
            VStack {
                AppTitleText()

                Spacer()

                LogEntryView(viewModel: viewModel)

                Spacer()
                Spacer()

                floatingButtons
            }

            if let activeOverlay {
                overlayView(for: activeOverlay)
                    .transition(.move(edge: .leading).combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: activeOverlay)
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
        case .progress:
            ProgressPlaceholderView(close: dismissOverlay)
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

private struct ProgressPlaceholderView: View {
    let close: () -> Void

    var body: some View {
        VStack(spacing: AppLayout.pageSpacing) {
            ProgressHeaderView(onBack: close)

            PageTitleText(title: "Progress")
                .padding(.top, AppLayout.titleTopPadding)

            Text("Coming soon")
                .foregroundStyle(.secondary)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
        .background(Color(.systemBackground))
    }
}

private struct ProgressHeaderView: View {
    let onBack: () -> Void

    var body: some View {
        HStack {
            Button(action: { onBack() }) {
                Circle()
                    .fill(AppColors.floatingButtonBackground)
                    .frame(width: AppLayout.floatingButtonSize, height: AppLayout.floatingButtonSize)
                    .shadow(color: AppColors.inputShadow, radius: AppLayout.floatingButtonShadowRadius, x: 0, y: AppLayout.floatingButtonShadowYOffset)
                    .overlay(
                        Image(systemName: "chevron.left")
                            .foregroundColor(AppColors.accent)
                            .font(.system(size: 18, weight: .semibold))
                    )
            }
            Spacer()
        }
    }
}

#Preview {
    HomeView(context: PersistenceController.shared.container.viewContext)
}
