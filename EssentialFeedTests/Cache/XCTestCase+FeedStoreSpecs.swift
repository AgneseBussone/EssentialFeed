// Constraint the protocol extension to XCTestCase and restraining the use to test only

import XCTest
import EssentialFeed

extension FeedStoreSpecs where Self: XCTestCase {
    @discardableResult
    func insert(_ cache: (feed: [LocalFeedImage], timestamp: Date), to sut: FeedStore, file: StaticString = #file, line: UInt = #line) -> Error? {
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
    func delete(from sut: FeedStore) -> Error? {
        let exp = expectation(description: "Wait for deletion")
        var deletionError: Error?
        sut.deleteCachedFeed { error in
            deletionError = error
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        return deletionError
    }
    
    func expect(_ sut: FeedStore, toRetrieveTwice expectedResult: RetrieveCachedFeedResult, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    func expect(_ sut: FeedStore, toRetrieve expectedResult: RetrieveCachedFeedResult, file: StaticString = #file, line: UInt = #line) {
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
}
