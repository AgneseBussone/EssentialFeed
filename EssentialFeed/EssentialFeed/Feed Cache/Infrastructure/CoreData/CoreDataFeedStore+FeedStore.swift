//

import Foundation

extension CoreDataFeedStore: FeedStore {
    
    public func deleteCachedFeed() throws {
        try ManagedCache.deleteCache(in: context)
    }
    
    public func insert(_ items: [EssentialFeed.LocalFeedImage], timestamp: Date) throws {
        let managedCache = try ManagedCache.newUniqueInstance(in: context)
        managedCache.timestamp = timestamp
        managedCache.feed = ManagedFeedImage.images(from: items, in: context)
        try context.save()
    }
    
    public func retrieve() throws -> CachedFeed? {
        try ManagedCache.find(in: context).map {
            CachedFeed(feed: $0.localFeed, timestamp: $0.timestamp)
        }
    }
}
