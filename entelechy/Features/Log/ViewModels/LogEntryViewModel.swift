//
//  LogEntryViewModel.swift
//  entelechy
//
//  Created by Angel Prieto on 11/28/25.
//

import Combine
import Foundation

final class LogEntryViewModel: ObservableObject {
    
    /* variables */

    private let repository: WeightEntryRepository
    private var cancellables: Set<AnyCancellable>
    
    private let calendar = Calendar.current
    
    @Published var validationErrorMessage: String?
    private var validationErrorMessageClearTask: Task<Void, Never>?

    /* init */
    
    init(repository: WeightEntryRepository) {
        self.repository = repository
        self.cancellables = []
        
        repository.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &self.cancellables)
    }

    deinit {
        self.validationErrorMessageClearTask?.cancel()
    }

    /* computed properties */
    
    var hasLoggedWeightToday: Bool {
        /* Returns whether a weight has already been logged today. */
        
        let today = self.calendar.startOfDay(for: Date())
        
        return self.repository.entries.contains { entry in
            self.calendar.startOfDay(for: entry.date) == today
        }
        
    }
    
    /* public functions */
    
    func submitWeight(_ input: String) -> Bool {
        /* Returns whether the input is valid or not, if so submits weight into data if possible. */
        
        guard let weight = self.validate(input) else {
            self.showValidationMessage("Enter a weight between 000.1 and 999.9.")
            return false
        }
        
        // Prevent multiple weights from being logged in a single day.
        if hasLoggedWeightToday {
            self.showValidationMessage("Weight has already been logged today.")
            return false
        }
        
        // Clear validation error message.
        self.validationErrorMessageClearTask?.cancel()
        self.validationErrorMessage = nil
        
        self.repository.addEntry(weight: weight)
        
        return true
        
    }
    
    func sanitize(_ input: String) -> String {
        /* Called by 'updateInput' to sanitize log being input. */
        
        // Return empty string in case input is empty.
        if input.count == 0 {
            return ""
        }
        
        // Remove all characters that are not numbers or a decimal from input.
        var filtered = input.filter { $0.isNumber || $0 == "." }
        
        // Add 0 to start if first character is a decimal.
        if filtered.first == "." {
            filtered = "0" + filtered
        }

        // Split input by decimal. Since our the maximum value our log allows is up to 999.9, our whole value would be up to the first 3 digits input. If there is no decimal in input the fourth digit would be our fractional, otherwise the first digit after the decimal would be our fractional. If there is no decimal the fractional is empty.
        let parts = filtered.split(separator: ".", omittingEmptySubsequences: false)
        
        let first = String(parts[0])
        
        let whole = String(first.prefix(3))
        let fractional: String

        if parts.count == 1 && first.count > 3 {
            fractional = "." + String(first.dropFirst(3).prefix(1))
        } else if parts.count > 1 {
            fractional = "." + String(parts[1].prefix(1))
        } else {
            fractional = ""
        }

        return whole + fractional
    }
    
    /* helper functions */

    private func validate(_ input: String) -> Double? {
        /* Validate weight and return input as a double if valid. */
        
        guard let value = Double(input), value >= 000.1, value <= 999.9 else {
            return nil
        }
        
        return value
        
    }
    
    private func showValidationMessage(_ message: String) {
        /* Shows a validation message temporarily. */
        
        self.validationErrorMessage = message
        self.validationErrorMessageClearTask?.cancel()
        
        //
        self.validationErrorMessageClearTask = Task { [weak self] in
            try? await Task.sleep(for: .seconds(2))
            
            guard !Task.isCancelled else {
                return
            }
            
            await MainActor.run {
                self?.validationErrorMessage = nil
            }
        }
        
    }
    
}
