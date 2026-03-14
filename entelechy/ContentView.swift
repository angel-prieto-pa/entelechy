//
//  ContentView.swift
//  entelechy
//
//  Created by Angel Prieto on 11/28/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = LogEntryViewModel()

    var body: some View {
        TabView {
            VStack(spacing: AppLayout.pageSpacing) {
                appTitle
                LogEntryView(viewModel: viewModel)
            }
            .tabItem {
                Label("Log", systemImage: "square.and.pencil")
            }

            VStack(spacing: AppLayout.pageSpacing) {
                appTitle
                CalendarView(viewModel: viewModel)
            }
            .tabItem {
                Label("History", systemImage: "calendar")
            }
        }
        .tint(AppColors.accent)
    }

    // Title
    private var appTitle: some View {
        
        Text("entelechy")
            .font(.system(.largeTitle, design: .serif))
            .fontWeight(.semibold)
            .padding(.top, AppLayout.titleTopPadding)
        
    }
}

#Preview {
    ContentView()
}
