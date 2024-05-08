//

import XCTest
import EssentialFeed

final class CoreDataFeedStoreTests: XCTestCase, FeedStoreSpecs {
    
    func test_retrieve_deliversEmptyOnEmptyCache() throws {
        try makeSUT { sut in
            self.assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
        }
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() throws {
        try makeSUT { sut in
            self.assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
        }
    }
    
    func test_retrieve_deliversFoundOnNonEmptyCache() throws {
        try makeSUT { sut in
            self.assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on: sut)
        }
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() throws {
        try makeSUT { sut in
            self.assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on: sut)
        }
    }
    
    func test_insert_deliversNoErrorOnEmptyCache() throws {
        try makeSUT { sut in
            self.assertThatInsertDeliversNoErrorOnEmptyCache(on: sut)
        }
    }
    
    func test_insert_deliversNoErrorOnNonEmptyCache() throws {
        try makeSUT { sut in
            self.assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut)
        }
    }
    
    func test_insert_overridesPreviouslyInsertedCacheValues()  throws {
        try makeSUT { sut in
            self.assertThatInsertOverridesPreviouslyInsertedCacheValues(on: sut)
        }
    }
    
    func test_delete_deliversNoErrorOnEmptyCache() throws {
        try makeSUT { sut in
            self.assertThatDeleteDeliversNoErrorOnEmptyCache(on: sut)
        }
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() throws {
        try makeSUT { sut in
            self.assertThatDeleteHasNoSideEffectsOnEmptyCache(on: sut)
        }
    }
    
    func test_delete_deliversNoErrorOnNonEmptyCache()  throws {
        try makeSUT { sut in
            self.assertThatDeleteDeliversNoErrorOnNonEmptyCache(on: sut)
        }
    }
    
    func test_delete_emptiesPreviouslyInsertedCache()  throws {
        try makeSUT { sut in
            self.assertThatDeleteEmptiesPreviouslyInsertedCache(on: sut)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(_ test: @escaping (CoreDataFeedStore) -> Void, file: StaticString = #file, line: UInt = #line) throws {
        // To load the Core Data store in CoreDataFeedStoreTests, which is part of the test target, we need to locate the Core Data data model in the bundle.
        // Since the data model file lives in the main production bundle which is different than the test bundle it’s essential that we choose the correct bundle to load the model from.
        // Production will use the default value.
        let storeBundle = Bundle(for: CoreDataFeedStore.self)
        
        // By using a file URL of /dev/null for the persistent store, the Core Data stack will not save SQLite artifacts to disk, doing the work in memory.
        // This means that this option is faster when running tests, as opposed to performing I/O and actually writing/reading from disk.
        // Moreover, when operating in-memory, you prevent cross test side-effects since this process doesn’t create any artifacts.
        let storeURL = URL(fileURLWithPath: "/dev/null")
        
        let sut = try! CoreDataFeedStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        let exp = expectation(description: "wait")
        sut.perform {
            test(sut)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
}
