//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>
    typealias InsertionResult = Swift.Result<Void, Error>
    
    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void)
    func retrieve(dataFor url: URL, completion: @escaping (Result) -> Void)
    func complete(with: Error, at index: Int)
    func complete(with data: Data?, at index: Int)
}
