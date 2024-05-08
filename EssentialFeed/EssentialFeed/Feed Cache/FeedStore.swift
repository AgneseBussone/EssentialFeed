//

import Foundation

public typealias CachedFeed = (feed: [LocalFeedImage], timestamp: Date)

public protocol FeedStore {
    func deleteCachedFeed() throws
    func insert(_ items: [LocalFeedImage], timestamp: Date) throws
    func retrieve() throws -> CachedFeed?
}
