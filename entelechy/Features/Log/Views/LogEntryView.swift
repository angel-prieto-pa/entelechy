//
//  LogEntryView.swift
//  entelechy
//
//  Created by Angel Prieto on 11/28/25.
//

import SwiftUI

struct LogEntryView: View {
    
    /* variables */
    
    @ObservedObject var viewModel: LogEntryViewModel
    
    @ScaledMetric(relativeTo: .title) private var inputHeight: CGFloat = 115.0
    @ScaledMetric(relativeTo: .title) private var inputCornerRadius: CGFloat = 30.0
    @ScaledMetric(relativeTo: .title) private var inputLineWidth: CGFloat = 2.5
    @ScaledMetric(relativeTo: .title) private var inputFontSize: CGFloat = 55.0
    
    private let inputVerticalPadding: CGFloat = 5.0
    private let inputHorizontalPadding: CGFloat = 0.75 * AppLayout.floatingButtonInset
    
    private let defaultText: String = "0.0"
    
    /* body */

    var body: some View {
        VStack() {
            
            // Title
            PageTitleText(title: "Log Weight")
            
            Spacer()
                .frame(maxHeight: AppLayout.titleSpacer)

            Group {
                // Input Box
                InputBox
                
                // Input Button
                InputButton
            }
            .padding(.vertical, self.inputVerticalPadding)
            .padding(.horizontal, self.inputHorizontalPadding)
            
//            .padding(.horizontal)
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
            
            Spacer()

        }

    }
    
    /* view components */

    // Input Box
    private var InputBox: some View {
        /* Box with text field to log weight and show unit of weight. */
        
        ZStack {
            
            // Outer Box
            RoundedRectangle(cornerRadius: self.inputCornerRadius, style: .continuous)
                .fill(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: self.inputCornerRadius, style: .continuous)
                        .stroke(Color(.separator), lineWidth: self.inputLineWidth)
                )
                .frame(height: self.inputHeight)

            // Text Field
            VStack() {
                
                // Weight Text
                TextField(self.defaultText, text: $viewModel.currentLog)
                    .keyboardType(.decimalPad)
                    .font(.system(size: self.inputFontSize, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .onChange(of: viewModel.currentLog) { _, newValue in
                        viewModel.updateInput(newValue)
                    }

                // Label Text
                Text(viewModel.unitLabel)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
            }
        }
    }
    
    // Input Button
    private var InputButton: some View {
        /* Button to log weight from text box. */
        
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
        
    }
    
}
