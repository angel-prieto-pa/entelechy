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
        let viewModel = try await TestHelpers.makeLogEntryViewModel()
        
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
        let viewModel = try await TestHelpers.makeLogEntryViewModel()
        
        #expect(viewModel.sanitize("185.67") == "185.6")
        #expect(viewModel.sanitize("1234") == "123.4")
        #expect(viewModel.sanitize("12345") == "123.4")
        #expect(viewModel.sanitize("99999") == "999.9")
    }
    
    @MainActor
    @Test func sanitizeWeightInputNormalizesDecimalInput() async throws {
        let viewModel = try await TestHelpers.makeLogEntryViewModel()
        
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
        let repository = try await TestHelpers.makeRepository()
        let viewModel = LogEntryViewModel(repository: repository)

        #expect(viewModel.submitWeight(input) == false)
        #expect(repository.entries.isEmpty)
        #expect(viewModel.validationErrorMessage == "Enter a weight between 000.1 and 999.9.")
        
    }

    @MainActor
    @Test(arguments: [".1", "0.1", "185.6", "64.3", "999.9"])
    func submitWeightAcceptsValidInput(input: String) async throws {
        let viewModel = try await TestHelpers.makeLogEntryViewModel()

        #expect(viewModel.submitWeight(input) == true)
        #expect(viewModel.validationErrorMessage == nil)
        
    }
    
    @MainActor
    @Test func submitWeightAddsValidEntry() async throws {
        let repository = try await TestHelpers.makeRepository()
        let viewModel = LogEntryViewModel(repository: repository)

        #expect(viewModel.submitWeight("185.6") == true)
        #expect(repository.entries.count == 1)
        #expect(repository.entries.first?.weight == 185.6)
        
    }
    
    @MainActor
    @Test func submitWeightRejectsMultipleEntries() async throws {
        let repository = try await TestHelpers.makeRepository()
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
        let viewModel = try await TestHelpers.makeLogEntryViewModel()
        
        #expect(viewModel.hasLoggedWeightToday == false)
    }
    
    @MainActor
    @Test func hasLoggedWeightTodayIsTrueAfterSubmittingWeight() async throws {
        let viewModel = try await TestHelpers.makeLogEntryViewModel()
        
        #expect(viewModel.submitWeight("185.6") == true)
        #expect(viewModel.hasLoggedWeightToday == true)
    }
    
    @MainActor
    @Test func hasLoggedWeightTodayIgnoresOlderEntries() async throws {
        let repository = try await TestHelpers.makeRepository()
        let viewModel = LogEntryViewModel(repository: repository)
        
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else {
            throw TestHelpers.TestStoreError.missingDate
        }
        
        repository.addEntry(weight: 185.6, on: yesterday)
        repository.refreshLocalData()
        
        #expect(viewModel.hasLoggedWeightToday == false)
    }
    
}

struct WeightEntryRepositoryTests {
    
    /* Tests */
    
    // Repository
    
    @MainActor
    @Test func repositoryStartsEmpty() async throws {
        let repository = try await TestHelpers.makeRepository()
        
        #expect(repository.entries.isEmpty)
        #expect(repository.weightYears.isEmpty)
        
    }
    
    @MainActor
    @Test func repositorySavesAndFetchesEntriesNewestFirst() async throws {
        let repository = try await TestHelpers.makeRepository()
        let olderDate = try TestHelpers.makeDate(year: 2026, month: 6, day: 1)
        let newerDate = try TestHelpers.makeDate(year: 2026, month: 6, day: 15)
        
        repository.addEntry(weight: 186.1, on: olderDate)
        repository.addEntry(weight: 185.2, on: newerDate)
        repository.refreshLocalData()
        
        #expect(repository.entries.count == 2)
        #expect(repository.entries[0].date == newerDate)
        #expect(repository.entries[0].weight == 185.2)
        #expect(repository.entries[1].date == olderDate)
        #expect(repository.entries[1].weight == 186.1)
    }
    
    @MainActor
    @Test func repositoryGroupsEntriesIntoYears() async throws {
        let repository = try await TestHelpers.makeRepository()
        let olderDate = try TestHelpers.makeDate(year: 2025, month: 6, day: 1)
        let newerDate = try TestHelpers.makeDate(year: 2026, month: 6, day: 1)
        
        repository.addEntry(weight: 186.1, on: olderDate)
        repository.addEntry(weight: 185.2, on: newerDate)
        repository.refreshLocalData()
        
        #expect(repository.weightYears.count == 2)
        
        let newerYear = repository.weightYears[0]
        let olderYear = repository.weightYears[1]
        
        let newerWeek = try TestHelpers.makeDate(year: 2026, month: 5, day: 31)
        let olderWeek = try TestHelpers.makeDate(year: 2025, month: 6, day: 1)
        
        #expect(newerYear.year == 2026)
        #expect(newerYear.weeks.count == 1)
        #expect(newerYear.weeks[0].logs[0].weight == 185.2)
        #expect(newerYear.weeks[0].id == newerWeek)
        
        #expect(olderYear.year == 2025)
        #expect(olderYear.weeks.count == 1)
        #expect(olderYear.weeks[0].logs[0].weight == 186.1)
        #expect(olderYear.weeks[0].id == olderWeek)
        
    }
    
    @MainActor
    @Test func repositorySplitsWeekAcrossYearBoundary() async throws {
        let repository = try await TestHelpers.makeRepository()
        let olderDate = try TestHelpers.makeDate(year: 2025, month: 12, day: 30)
        let newerDate = try TestHelpers.makeDate(year: 2026, month: 1, day: 1)
        
        repository.addEntry(weight: 186.1, on: olderDate)
        repository.addEntry(weight: 185.2, on: newerDate)
        repository.refreshLocalData()
        
        #expect(repository.weightYears.count == 2)
        
        let newerYear = repository.weightYears[0]
        let olderYear = repository.weightYears[1]
        
        let newerWeek = newerDate
        let olderWeek = try TestHelpers.makeDate(year: 2025, month: 12, day: 28)
        
        #expect(newerYear.year == 2026)
        #expect(newerYear.weeks.count == 1)
        #expect(newerYear.weeks[0].logs[0].weight == 185.2)
        #expect(newerYear.weeks[0].id == newerWeek)
        
        #expect(olderYear.year == 2025)
        #expect(olderYear.weeks.count == 1)
        #expect(olderYear.weeks[0].logs[0].weight == 186.1)
        #expect(olderYear.weeks[0].id == olderWeek)
        
    }
    
    @MainActor
    @Test func repositoryGroupsEntriesIntoYearsAndWeeks() async throws {
        let repository = try await TestHelpers.makeRepository()
        let olderDate = try TestHelpers.makeDate(year: 2026, month: 6, day: 1)
        let newerDate = try TestHelpers.makeDate(year: 2026, month: 6, day: 15)
        
        repository.addEntry(weight: 186.1, on: olderDate)
        repository.addEntry(weight: 185.2, on: newerDate)
        repository.refreshLocalData()
        
        #expect(repository.weightYears.count == 1)

        let year = repository.weightYears[0]
        #expect(year.year == 2026)
        #expect(year.weeks.count == 2)
        
        let olderWeek = try TestHelpers.makeDate(year: 2026, month: 5, day: 31)
        let newerWeek = try TestHelpers.makeDate(year: 2026, month: 6, day: 14)

        #expect(year.weeks[0].logs.count == 1)
        #expect(year.weeks[0].id == newerWeek)
        #expect(year.weeks[0].logs[0].date == newerDate)
        #expect(year.weeks[0].logs[0].weight == 185.2)

        #expect(year.weeks[1].logs.count == 1)
        #expect(year.weeks[1].id == olderWeek)
        #expect(year.weeks[1].logs[0].date == olderDate)
        #expect(year.weeks[1].logs[0].weight == 186.1)
        
    }
    
    @MainActor
    @Test func repositoryGroupsMultipleEntriesInSameWeek() async throws {
        let repository = try await TestHelpers.makeRepository()
        let olderDate = try TestHelpers.makeDate(year: 2026, month: 6, day: 1)
        let newerDate = try TestHelpers.makeDate(year: 2026, month: 6, day: 6)
        
        repository.addEntry(weight: 186.1, on: olderDate)
        repository.addEntry(weight: 185.2, on: newerDate)
        repository.refreshLocalData()
        
        #expect(repository.weightYears.count == 1)

        let year = repository.weightYears[0]
        #expect(year.year == 2026)
        #expect(year.weeks.count == 1)
        
        let week = try TestHelpers.makeDate(year: 2026, month: 5, day: 31)

        #expect(year.weeks[0].logs.count == 2)
        #expect(year.weeks[0].id == week)
        
        #expect(year.weeks[0].logs[0].date == newerDate)
        #expect(year.weeks[0].logs[0].weight == 185.2)
        #expect(year.weeks[0].logs[1].date == olderDate)
        #expect(year.weeks[0].logs[1].weight == 186.1)
        
    }

}

private enum TestHelpers {

    @MainActor
    static func makeRepository() async throws -> WeightEntryRepository {
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
    static func makeLogEntryViewModel() async throws -> LogEntryViewModel {
        /* Returns LogEntryViewModel. */
        LogEntryViewModel(repository: try await Self.makeRepository())
    }
    
    static func makeDate(year: Int, month: Int, day: Int) throws -> Date {
        /* Returns date. */
        guard let date = Calendar.current.date(from: DateComponents(year: year, month: month, day: day)) else {
            throw TestStoreError.missingDate
        }
        
        return date
    }
    
    // Errors

    enum TestStoreError: Error {
        case missingModel
        case missingDate
    }

}
