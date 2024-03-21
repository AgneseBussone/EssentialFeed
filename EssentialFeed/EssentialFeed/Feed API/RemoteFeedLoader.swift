// public access to allow the test suite to access the class/methods

import Foundation

public typealias RemoteFeedLoader = RemoteLoader<[FeedImage]>

extension RemoteFeedLoader {
    convenience public init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: FeedItemsMapper.map)
    }
}
