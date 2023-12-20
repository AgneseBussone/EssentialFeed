// public access to allow the test suite to access the class/methods

import Foundation

public final class RemoteFeedLoader: FeedLoader {
    private let url: URL
    private let client: HTTPClient
        
    // we have to use the namespace because it's the same name
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = LoadFeedResult
    
    // the RemoteFeedLoader doesn't need to know details about url and http client,
    // so they can simply be passed in as dependencies
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (LoadFeedResult) -> Void) {
        client.get(from: url) { [weak self] result in
            
            // avoid running the completion block in case the instance of the RemoteFeedLoader has been destroyed
            // comment this to see the failing test!!
            guard self != nil else { return }
            
            switch result {
            case let .success(data, response):
                completion(FeedItemsMapper.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}

