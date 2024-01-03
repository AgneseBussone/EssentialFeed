// This is a local representation for the FeedItem.
// It might seem like a duplication, but in the cache we might want to store additional properties unrelated to the shared FeedItem.

import Foundation

public struct LocalFeedImage: Equatable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let url: URL
    
    // we need to add the initialiser explicitly because the default one is not public
    public init(id: UUID, description: String?, location: String?, url: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.url = url
    }
}
