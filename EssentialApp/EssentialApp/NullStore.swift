// This class provides a safe implementation of the Store used by the app.
// In case CoreData fails, it's possible to just provide a void implementation: the cache is not vital for this app.
// All the funcs return with a reasonable completion in order to avoid the caller to hang waiting for the response.
// In other cases, a different behaviour might make more sense than this. It depends on the app/use case/importance of the component for the app/etc....

import Foundation
import EssentialFeed

class NullStore: FeedStore & FeedImageDataStore {
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        completion(.success(()))
    }
    
    func insert(_ items: [EssentialFeed.LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        completion(.success(()))
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.success(.none))
    }
    
    // MARK: - FeedImageDataStore
    
    func insert(_ data: Data, for url: URL) throws { }

    func retrieve(dataForURL url: URL) throws -> Data? {
        .none
    }
}
