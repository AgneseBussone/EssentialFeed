// Internal class that hides api detail from the public api
// These are Decodable and the property names match the json schema, so no need for CodingKeys enum here

import Foundation

internal final class FeedItemsMapper {
    
    private struct Root: Decodable {
        let items: [NetworkItem]
    }

    private static var OK_200: Int { return 200 }

    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [NetworkItem] {
        guard response.statusCode == OK_200,
            let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }

        return root.items
    }
}
