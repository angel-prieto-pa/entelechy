//
//  HomeView.swift
//  entelechy
//
//  Created by Angel Prieto on 11/28/25.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    @StateObject private var viewModel: LogEntryViewModel
    
    @State private var isHistoryPresented = false
    @State private var isProgressPresented = false

    init(context: NSManagedObjectContext) {
        // View Model relies on persistence container context to mangae data.
        _viewModel = StateObject(wrappedValue: LogEntryViewModel(context: context))
    }

    var body: some View {
            
        VStack() {
            
            appTitle
            
            Spacer()
            
            LogEntryView(viewModel: viewModel)
            
            Spacer()
            Spacer()
            
            floatingButtons
            
        }
            
    }

    // Title
    private var appTitle: some View {
        Text("entelechy")
            .font(.system(.largeTitle, design: .serif))
            .fontWeight(.semibold)
            .padding(.top, AppLayout.titleTopPadding)
    }

    private var floatingButtons: some View {
            
        HStack {
                
            // History
            CircleButton(
                image: Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90"),
                action: { isHistoryPresented = true },
                isPresented: $isHistoryPresented
            ) {
                HistoryView(viewModel: viewModel)
            }

            Spacer()
                
            // Progress
            CircleButton(
                image: Image(systemName: "chart.line.uptrend.xyaxis"),
                action: { isProgressPresented = true },
                isPresented: $isProgressPresented
            ) {
                ProgressPlaceholderView()
            }

        }
        .padding(.horizontal, AppLayout.floatingButtonInset)
            
        
    }

}

private struct ProgressPlaceholderView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: AppLayout.pageSpacing) {
            ProgressHeaderView(onBack: { dismiss() })

            PageTitleText(title: "Progress")
                .padding(.top, AppLayout.titleTopPadding)

            Text("Coming soon")
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding()
    }
}

private struct ProgressHeaderView: View {
    let onBack: () -> Void

    var body: some View {
        HStack {
            Button(action: onBack) {
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
