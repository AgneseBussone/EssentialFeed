//

import Foundation

public protocol FeedImageDataStore {
    typealias RetrievalResult = Swift.Result<Data?, Error>
    typealias InsertionResult = Swift.Result<Void, Error>
    
    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void)
    func retrieve(dataFor url: URL, completion: @escaping (RetrievalResult) -> Void)
    func completeRetrieval(with: Error, at index: Int)
    func completeRetrieval(with data: Data?, at index: Int)
}
