//

import Foundation

extension CoreDataFeedStore {
    
    public func insert(_ data: Data, for url: URL, completion: @escaping (FeedImageDataStore.InsertionResult) -> Void) {
        
    }
    
    public func retrieve(dataForURL: URL, completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
        completion(.success(.none))
    }
}
