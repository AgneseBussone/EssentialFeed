//

import XCTest
import EssentialFeed

final class CodableFeedStoreTests: XCTestCase {
    
    override func tearDown() {
        super.tearDown()
        cleanStore()
    }

    override func setUp() {
        super.setUp()
        cleanStore()
    }

    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        expect(sut, toRetrieve: .empty)
    }

    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toRetrieveTwice: .empty)
    }

    func test_retrieve_deliversFoundOnNonEmptyCache() {
        let sut = makeSUT()
        let feed = uniqueItems().local
        let timestamp = Date()
        
        insert((feed, timestamp: timestamp), to: sut)
        
        expect(sut, toRetrieve: .found(feed: feed, timestamp: timestamp))
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        let feed = uniqueItems().local
        let timestamp = Date()
        
        insert((feed, timestamp: timestamp), to: sut)
        
        expect(sut, toRetrieveTwice: .found(feed: feed, timestamp: timestamp))
    }
    
    func test_retrieve_deliversFailureOnRetrievalError() {
        let storeURL = testStoreURL()
        let sut = makeSUT(storeURL: testStoreURL())
        
        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        expect(sut, toRetrieve: .failure(anyNSError()))
    }

    func test_retrieve_hasNoSideEffectsOnFailure() {
        let storeURL = testStoreURL()
        let sut = makeSUT(storeURL: testStoreURL())
        
        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        expect(sut, toRetrieveTwice: .failure(anyNSError()))
    }
    
    func test_insert_deliversNoErrorOnEmptyCache() {
        let sut = makeSUT()
        
        let insertionError = insert((uniqueItems().local, Date()), to: sut)
        XCTAssertNil(insertionError, "Expected to insert into cahce successfully")
    }
    
    func test_insert_deliversNoErrorOnNonEmptyCache() {
        let sut = makeSUT()
        insert((uniqueItems().local, Date()), to: sut)
        
        let insertionError = insert((uniqueItems().local, Date()), to: sut)
        
        XCTAssertNil(insertionError, "Expected to override cache successfully")
    }
    
    func test_insert_overridesPreviouslyInsertedCacheValues() {
        let sut = makeSUT()
        insert((uniqueItems().local, Date()), to: sut)
        
        let latestFeed = uniqueItems().local
        let latestTimestamp = Date()
        insert((latestFeed, latestTimestamp), to: sut)
        
        expect(sut, toRetrieve: .found(feed: latestFeed, timestamp: latestTimestamp))
    }
    
    func test_insert_deliversErrorOnInsertionError() {
        let invalidStoreUrl = URL(string: "invalid://store-url")
        let sut = makeSUT(storeURL: invalidStoreUrl)
        let feed = uniqueItems().local
        let timestamp = Date()
        
        let insertionError = insert((feed, timestamp), to: sut)
        
        XCTAssertNotNil(insertionError, "Expected cache insertion error")
    }

    func test_insert_hasNoSideEffectsOnInsertionError() {
        let invalidStoreUrl = URL(string: "invalid://store-url")
        let sut = makeSUT(storeURL: invalidStoreUrl)
        let feed = uniqueItems().local
        let timestamp = Date()
        
        insert((feed, timestamp), to: sut)
        
        expect(sut, toRetrieve: .empty)
    }

    func test_delete_deliversNoErrorOnEmptyCache() {
        let sut = makeSUT()
        
        let deletionError = delete(from: sut)
        
        XCTAssertNil(deletionError, "Expected empty cache deletion to succeed")
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        delete(from: sut)
        
        expect(sut, toRetrieve: .empty)
    }
    
    func test_delete_deliversNoErrorOnNonEmptyCache() {
        let sut = makeSUT()
        insert((uniqueItems().local, Date()), to: sut)
        
        let deletionError = delete(from: sut)
        
        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed")
    }
    
    func test_delete_emptiesPreviouslyInsertedCache() {
        let sut = makeSUT()
        insert((uniqueItems().local, Date()), to: sut)
        
        delete(from: sut)
        
        expect(sut, toRetrieve: .empty)
    }
    
    func test_delete_deliversErrorOnDeletionError() {
        let noDeletePermissionURL = cachesDirectory()
        let sut = makeSUT(storeURL: noDeletePermissionURL)
        
        let deletionError = delete(from: sut)

        XCTAssertNotNil(deletionError, "Expected deletion error")
    }
    
    func test_delete_hasNoSideEffectsOnDeletionError() {
        let noDeletePermissionURL = cachesDirectory()
        let sut = makeSUT(storeURL: noDeletePermissionURL)

        delete(from: sut)

        expect(sut, toRetrieve: .empty)
    }
    
    func test_storeSideEffects_runSerially() {
        let sut = makeSUT()
        var completedOperationsInOrder = [XCTestExpectation]()
        
        let op1 = expectation(description: "Operation 1")
        sut.insert(uniqueItems().local, timestamp: Date()) { _ in
            completedOperationsInOrder.append(op1)
            op1.fulfill()
        }
        
        let op2 = expectation(description: "Operation 2")
        sut.deleteCachedFeed { _ in
            completedOperationsInOrder.append(op2)
            op2.fulfill()
        }
        
        let op3 = expectation(description: "Operation 3")
        sut.insert(uniqueItems().local, timestamp: Date()) { _ in
            completedOperationsInOrder.append(op3)
            op3.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
        
        XCTAssertEqual(completedOperationsInOrder, [op1, op2, op3], "Expected side-effects to run serially but operations finished in wrong order")
    }
    
    // MARK: - Helpers
    
    func makeSUT(storeURL: URL? = nil, file: StaticString = #file, line: UInt = #line) -> FeedStore {
        let sut = CodableFeedStore(storeURL: storeURL ?? testStoreURL())
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    @discardableResult
    private func insert(_ cache: (feed: [LocalFeedImage], timestamp: Date), to sut: FeedStore, file: StaticString = #file, line: UInt = #line) -> Error? {
        let exp = expectation(description: "Wait for cache insertion")
        var insertionError: Error?
        sut.insert(cache.feed, timestamp: cache.timestamp) { receivedInsertionError in
            XCTAssertNil(insertionError, "Expected feed to be inserted successfully")
            insertionError = receivedInsertionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        
        return insertionError
    }
    
    @discardableResult
    private func delete(from sut: FeedStore) -> Error? {
        let exp = expectation(description: "Wait for deletion")
        var deletionError: Error?
        sut.deleteCachedFeed { error in
            deletionError = error
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        return deletionError
    }
    
    private func expect(_ sut: FeedStore, toRetrieveTwice expectedResult: RetrieveCachedFeedResult, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    private func expect(_ sut: FeedStore, toRetrieve expectedResult: RetrieveCachedFeedResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")

        sut.retrieve { receivedResult in
            switch (expectedResult, receivedResult) {
            case (.empty, .empty),
                (.failure, .failure):
                break
                
            case let (.found(expectedFeed, expectedTimestamp), .found(receivedFeed, receivedTimestamp)):
                XCTAssertEqual(receivedFeed, expectedFeed, file: file, line: line)
                XCTAssertEqual(receivedTimestamp, expectedTimestamp, file: file, line: line)
                
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(receivedResult)", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func testStoreURL() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    private func cleanStore() {
        try? FileManager.default.removeItem(at: testStoreURL())
    }

}
