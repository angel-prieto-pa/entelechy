//
//  LogEntryView.swift
//  entelechy
//
//  Created by Angel Prieto on 11/28/25.
//

import SwiftUI

struct LogEntryView: View {
    
    /* variables */
    
    @ObservedObject private var viewModel: LogEntryViewModel
    
    @State private var currentLog: String = ""
    
    @ScaledMetric(relativeTo: .title) private var inputHeight: CGFloat = 115.0
    @ScaledMetric(relativeTo: .title) private var inputCornerRadius: CGFloat = 30.0
    @ScaledMetric(relativeTo: .title) private var inputLineWidth: CGFloat = 2.5
    @ScaledMetric(relativeTo: .title) private var inputFontSize: CGFloat = 55.0
    
    private let inputVerticalPadding: CGFloat = 5.0
    
    private let defaultText: String = "0.0"
    
    /* init */
    
    init(viewModel: LogEntryViewModel) {
        self.viewModel = viewModel
    }
    
    /* body */

    var body: some View {
        VStack() {
            
            // Title
            PageTitleText(title: "Log Weight")
            
            Spacer()
                .frame(maxHeight: AppLayout.titleSpacer)

            Group {
                
                if self.viewModel.hasLoggedWeightToday {
                    
                    // Logged State
                    self.loggedState
                    
                } else {
                    
                    // Input Box
                    self.inputBox
                    
                    // Input Button
                    self.inputButton
                    
                    // Error Message
                    if let validationErrorMessage = self.viewModel.validationErrorMessage {
                        Text(validationErrorMessage)
                            .font(.footnote.weight(.medium))
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                    }
                    
                }
            }
            .padding(.vertical, self.inputVerticalPadding)
            
            Spacer()

        }

    }
    
    /* view components */

    // Logged State
    private var loggedState: some View {
        /* Confirmation view shown after today's weight has been logged. */
        
        VStack(spacing: AppLayout.contentVerticalPadding) {
            
            // Check
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 55.0, weight: .semibold))
                .foregroundStyle(AppColors.accent)
                .padding(5.0 * self.inputVerticalPadding)
            
            Text("Weight Logged Today")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary)
                .padding(2.5 * self.inputVerticalPadding)
            
            Text("Come back tomorrow to log your next weight.")
                .font(.subheadline.weight(.regular))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        
    }
    
    // Input Box
    private var inputBox: some View {
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
                TextField(self.defaultText, text: self.$currentLog)
                    .keyboardType(.decimalPad)
                    .font(.system(size: self.inputFontSize, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .onChange(of: self.currentLog) { _, updatedLog in
                        self.currentLog = self.viewModel.sanitize(updatedLog)
                    }

                // Label Text
                Text(AppInfo.unitLabel)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
            }
        }
    }
    
    // Input Button
    private var inputButton: some View {
        /* Button to log weight from text box. */
        
        Button(action: {
            
            if self.viewModel.submitWeight(self.currentLog) {
                self.currentLog = ""
            }
            
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
