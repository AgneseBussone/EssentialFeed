//

import XCTest
import EssentialFeed

protocol FeedImageDataCache {
    typealias Result = Swift.Result<Void, Swift.Error>

    func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}

class FeedImageDataLoaderCacheDecorator: FeedImageDataLoader {
    private let decoratee: FeedImageDataLoader
    private let cache: FeedImageDataCache
    
    init(decoratee: FeedImageDataLoader, cache: FeedImageDataCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        decoratee.loadImageData(from: url) { result in
            completion(result)
        }
    }
}

final class FeedImageDataLoaderCacheDecoratorTests: XCTestCase, FeedImageDataLoaderTestCase {

    func test_loadImageData_deliversDataOnLoaderSuccess() {
        let data = anyData()
        let sut = makeSUT(loaderResult: .success(data))
        
        expect(sut, toCompleteWith: .success(data))
    }
    
    // MARK: - Helpers
    
    private func makeSUT(loaderResult: FeedImageDataLoader.Result, cache: CacheSpy = .init(), file: StaticString = #file, line: UInt = #line) -> FeedImageDataLoader {
        let loader = FeedImageDataLoaderStub(result: loaderResult)
        let sut = FeedImageDataLoaderCacheDecorator(decoratee: loader, cache: cache)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private class CacheSpy: FeedImageDataCache {
        private(set) var messages = [Message]()
        
        enum Message: Equatable {
            case save(Data, URL)
        }
        
        func save(_ data: Data, for url: URL, completion: @escaping (FeedImageDataCache.Result) -> Void) {
            messages.append(.save(data, url))
            completion(.success(()))
        }
    }
    
}
