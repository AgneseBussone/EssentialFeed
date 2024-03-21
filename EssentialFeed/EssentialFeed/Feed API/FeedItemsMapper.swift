// Internal class that hides api detail from the public api
// These are Decodable and the property names match the json schema, so no need for CodingKeys enum here

import Foundation

internal final class FeedItemsMapper {
    
    private struct Root: Decodable {
        private let items: [RemoteFeedItem]
        
        private struct RemoteFeedItem: Decodable {
            internal let id: UUID
            internal let description: String?
            internal let location: String?
            internal let image: URL
        }
        
        var images: [FeedImage] {
            items.map { FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.image)}
        }
    }

    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [FeedImage] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }

        return root.images
    }
}
