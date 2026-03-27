//
//  LogEntryView.swift
//  entelechy
//
//  Created by Angel Prieto on 11/28/25.
//

import SwiftUI

struct LogEntryView: View {
    
    @ObservedObject var viewModel: LogEntryViewModel
    
    // TODO: Decide if I want to have page specific values or general.
    @ScaledMetric(relativeTo: .title) private var inputHeight: CGFloat = AppLayout.inputHeight
    @ScaledMetric(relativeTo: .title) private var inputCornerRadius: CGFloat = AppLayout.inputCornerRadius
    @ScaledMetric(relativeTo: .title) private var inputFontSize: CGFloat = AppLayout.inputFontSize

    var body: some View {
        VStack(spacing: AppLayout.sectionSpacing) {
            
            // Title
            PageTitleText(title: "Log Weight")

            // Input Box
            input

            // Submit Button (Log)
            Button(action: {
                viewModel.submitWeight()
            }) {
                Text("Log")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppLayout.buttonVerticalPadding)
                    .background(AppColors.accent)
                    .foregroundColor(.white)
                    .cornerRadius(AppLayout.buttonCornerRadius)
            }
            .padding(.horizontal)
//            .disabled(!viewModel.isSubmitEnabled)
//
//            List(viewModel.entryLog) { entry in
//                HStack {
//                    Text("\(entry.weight, specifier: "%.1f") \(viewModel.unitLabel)")
//                    Spacer()
//                    Text(entry.date, style: .date)
//                        .foregroundColor(.secondary)
//                }
//            }
        }
        .padding()
    }

    // Input
    private var input: some View {
        /* Box where user logs weight each day. */
        
        ZStack {
            
            // Outer Box
            RoundedRectangle(cornerRadius: inputCornerRadius, style: .continuous)
                .fill(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: inputCornerRadius, style: .continuous)
                        .stroke(Color(.separator), lineWidth: 2.5)
                )
                .frame(height: inputHeight)
                .padding(.horizontal)

            // Text Field
            VStack(spacing: 4) {
                TextField("0.0", text: $viewModel.currentLog)
                    .keyboardType(.decimalPad)
                    .font(.system(size: inputFontSize, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .onChange(of: viewModel.currentLog) { _, newValue in
                        viewModel.updateInput(newValue)
                    }

                Text(viewModel.unitLabel)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
