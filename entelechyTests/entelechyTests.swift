//
//  entelechyTests.swift
//  entelechyTests
//
//  Created by Angel Prieto on 11/28/25.
//

import CoreData
import Testing
@testable import entelechy

struct LogEntryViewModelTests {
    
    /* Tests */
    
    // Sanitize
    
    @MainActor
    @Test func sanitizeWeightInputRemovesInvalidCharacters() async throws {
        let viewModel = try await Self.makeViewModel()
        
        #expect(viewModel.sanitize("185.6 lbs") == "185.6")
        #expect(viewModel.sanitize("185a") == "185")
        #expect(viewModel.sanitize("185.") == "185.")
        #expect(viewModel.sanitize("-") == "")
        #expect(viewModel.sanitize("$7") == "7")
        #expect(viewModel.sanitize("185.6") == "185.6")
        #expect(viewModel.sanitize("999.9") == "999.9")
    
    }
    
    @MainActor
    @Test func sanitizeWeightInputLimitsPrecision() async throws {
        let viewModel = try await Self.makeViewModel()
        
        #expect(viewModel.sanitize("185.67") == "185.6")
        #expect(viewModel.sanitize("1234") == "123.4")
        #expect(viewModel.sanitize("12345") == "123.4")
        #expect(viewModel.sanitize("99999") == "999.9")
    }
    
    @MainActor
    @Test func sanitizeWeightInputNormalizesDecimalInput() async throws {
        let viewModel = try await Self.makeViewModel()
        
        #expect(viewModel.sanitize(".7") == "0.7")
        #expect(viewModel.sanitize(".") == "0.")
        #expect(viewModel.sanitize("..") == "0.")
        #expect(viewModel.sanitize(".1.") == "0.1")
        #expect(viewModel.sanitize("") == "")
    }
    
    // Submit Weight
    
    @MainActor
    @Test(arguments: ["", "0", "0.0", "1000", "1000.0", "185.6 lbs", "abc", "-1"])
    func submitWeightRejectsInvalidInput(input: String) async throws {
        let viewModel = try await Self.makeViewModel()

        #expect(viewModel.submitWeight(input) == false)
        #expect(viewModel.validationErrorMessage == "Enter a weight between 000.1 and 999.9.")
        
    }

    @MainActor
    @Test(arguments: [".1", "0.1", "185.6", "64.3", "999.9"])
    func submitWeightAcceptsValidInput(input: String) async throws {
        let viewModel = try await Self.makeViewModel()

        #expect(viewModel.submitWeight(input) == true)
        #expect(viewModel.validationErrorMessage == nil)
        
    }
    
    @MainActor
    @Test func submitWeightAddsValidEntry() async throws {
        let repository = try await Self.makeRepository()
        let viewModel = LogEntryViewModel(repository: repository)

        #expect(viewModel.submitWeight("185.6") == true)
        #expect(repository.entries.count == 1)
        #expect(repository.entries.first?.weight == 185.6)
        
    }
    
    @MainActor
    @Test func submitWeightRejectsInvalidEntry() async throws {
        let repository = try await Self.makeRepository()
        let viewModel = LogEntryViewModel(repository: repository)

        #expect(viewModel.submitWeight("1000") == false)
        #expect(repository.entries.isEmpty)
        
    }
    
    @MainActor
    @Test func submitWeightRejectsMultipleEntries() async throws {
        let repository = try await Self.makeRepository()
        let viewModel = LogEntryViewModel(repository: repository)

        #expect(viewModel.submitWeight("185.6") == true)
        #expect(repository.entries.count == 1)
        #expect(repository.entries.first?.weight == 185.6)
        
        #expect(viewModel.submitWeight("test") == false)
        #expect(viewModel.validationErrorMessage == "Enter a weight between 000.1 and 999.9.")
        #expect(repository.entries.count == 1)
        #expect(repository.entries.first?.weight == 185.6)
        
        #expect(viewModel.submitWeight("185.7") == false)
        #expect(viewModel.validationErrorMessage == "Weight has already been logged today.")
        #expect(repository.entries.count == 1)
        #expect(repository.entries.first?.weight == 185.6)
        
    }
    
    // Has Logged Weight Today
    
    @MainActor
    @Test func hasLoggedWeightTodayIsFalseWhenRepositoryIsEmpty() async throws {
        let viewModel = try await Self.makeViewModel()
        
        #expect(viewModel.hasLoggedWeightToday == false)
    }
    
    @MainActor
    @Test func hasLoggedWeightTodayIsTrueAfterSubmittingWeight() async throws {
        let viewModel = try await Self.makeViewModel()
        
        #expect(viewModel.submitWeight("185.6") == true)
        #expect(viewModel.hasLoggedWeightToday == true)
    }
    
    @MainActor
    @Test func hasLoggedWeightTodayIgnoresOlderEntries() async throws {
        let repository = try await Self.makeRepository()
        let viewModel = LogEntryViewModel(repository: repository)
        
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else {
            throw TestStoreError.missingDate
        }
        
        repository.addEntry(weight: 185.6, on: yesterday)
        repository.refreshLocalData()
        
        #expect(viewModel.hasLoggedWeightToday == false)
    }

    /* Private Helpers */

    @MainActor
    private static func makeRepository() async throws -> WeightEntryRepository {
        /* Returns a Core Data environment for testing, to avoid interfering with stored data. */
        
        // Bundle containing WeightEntry Core Data class and model resources.
        let bundle = Bundle(for: WeightEntry.self)

        // Core Data managed object model loaded from bundle.
        guard let model = NSManagedObjectModel.mergedModel(from: [bundle]) else {
            throw TestStoreError.missingModel
        }
        
        /* Persistent Container */
        let container = NSPersistentContainer(name: "WeightModel", managedObjectModel: model)
        
        /* Persistent Store Configuration */
        let description = NSPersistentStoreDescription()
        
        // Use in-memory store rather than disk.
        description.type = NSInMemoryStoreType
        // Apply configuration to container, before loading persistent store.
        container.persistentStoreDescriptions = [description]

        // Load in-memory persistent store.
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            
            container.loadPersistentStores { _, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
            
        }
        
        // Returns repository backed by an in-memory managed object context.
        return WeightEntryRepository(context: container.viewContext)
        
    }
    
    @MainActor
    private static func makeViewModel() async throws -> LogEntryViewModel {
        /* Returns view model. */
        LogEntryViewModel(repository: try await Self.makeRepository())
    }

    private enum TestStoreError: Error {
        case missingModel
        case missingDate
    }

}
