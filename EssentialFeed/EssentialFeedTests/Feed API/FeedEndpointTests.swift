//

import XCTest
import EssentialFeed

final class FeedEndpointTests: XCTestCase {

    func test_feed_endpointURL() {
        let baseURL = URL(string: "https://base-url.com")!
        
        let received = FeedEndpoint.get().url(baseURL: baseURL)
        
        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "/v1/feed", "path")
        XCTAssertEqual(received.query, "limit=10", "query")
    }

    func test_feed_endpointURLAfterGivenImage() {
        let baseURL = URL(string: "https://base-url.com")!
        let image = uniqueItem()
        let received = FeedEndpoint.get(after: image).url(baseURL: baseURL)
        
        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "/v1/feed", "path")
        // use contains because the order of the query params is irrelevant
        XCTAssertEqual(received.query?.contains("limit=10"), true, "query")
        XCTAssertEqual(received.query?.contains("after_id=\(image.id)"), true, "query")
    }

}
