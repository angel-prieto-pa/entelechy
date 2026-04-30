//
//  ProgressViewModel.swift
//  entelechy
//
//  Created by Angel Prieto on 4/29/26.
//

import Combine
import Foundation

final class ProgressViewModel: ObservableObject {
    
    /* variables */
    
    private let repository: WeightEntryRepository
    private var cancellables: Set<AnyCancellable>
    
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
    
}
