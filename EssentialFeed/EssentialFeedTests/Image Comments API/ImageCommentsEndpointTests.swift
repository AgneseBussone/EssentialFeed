//

import XCTest
import EssentialFeed

final class ImageCommentsEndpointTests: XCTestCase {

    func test_imageComments_endpointURL() {
        let baseURL = URL(string: "https://base-url.com")!
        
        let uuid = UUID()
        let received = ImageCommentsEndpoint.get(uuid).url(baseURL: baseURL)
        
        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "/v1/image/\(uuid.uuidString)/comments", "path")
    }

}
