//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>
    
    func retrieve(dataFor url: URL, completion: @escaping (FeedImageDataStore.Result) -> Void)
    func complete(with: Error, at index: Int)
    func complete(with data: Data?, at index: Int)
}
