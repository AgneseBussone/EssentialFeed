//

import Foundation
import EssentialFeed

func uniqueItem() -> FeedImage {
    return FeedImage(id: UUID(), description: "any", location: nil, url: anyURL())
}

func uniqueItems() -> (models: [FeedImage], local: [CacheItem]) {
    let models = [uniqueItem(), uniqueItem()]
    let local = models.map { CacheItem(id: $0.id, description: $0.description, location: $0.location, url: $0.url)}
    return (models, local)
}

// Extension for cache policies
extension Date {
    private var feedCacheMaxAgeInDays: Int {
        return 7
    }
    
    func minusFeedCacheMaxAge() -> Date {
        return adding(days: -feedCacheMaxAgeInDays)
    }
    
    private func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
}
    
// Generic extension on the type
extension Date {
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
