//

import Foundation

extension CoreDataFeedStore: FeedStore {
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        perform { context in
            completion(Result {
                try ManagedCache.deleteCache(in: context)
            })
        }
    }
    
    public func insert(_ items: [EssentialFeed.LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        perform { context in
            completion(Result {
                let managedCache = try ManagedCache.newUniqueInstance(in: context)
                managedCache.timestamp = timestamp
                managedCache.feed = ManagedFeedImage.images(from: items, in: context)
                try context.save()
            })
        }
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        perform { context in
            completion(Result {
                try ManagedCache.find(in: context).map {
                    CachedFeed(feed: $0.localFeed, timestamp: $0.timestamp)
                }
            })
        }
    }
}
