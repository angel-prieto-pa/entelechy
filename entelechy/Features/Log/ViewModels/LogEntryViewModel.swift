//
//  LogEntryViewModel.swift
//  entelechy
//
//  Created by Angel Prieto on 11/28/25.
//

final class LogEntryViewModel {
    
    /* variables */

    private let repository: WeightEntryRepository

    /* init */
    
    init(repository: WeightEntryRepository) {
        self.repository = repository
    }

    /* public functions */
    
    func submitWeight(_ input: String) {
        let weight = self.validate(input)
        self.repository.addEntry(weight: weight)
    }
    
    func sanitize(_ input: String) -> String {
        /* Called by 'updateInput' to sanitize log being inputted. */
        
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

    private func validate(_ input: String) -> Double {
        /* Validate weight and return input as a double. */
        
        guard let value = Double(input), value >= 000.0, value <= 999.9 else {
            // TODO: throw error
            return 0.0
        }
        
        return value
        
    }
    
}
