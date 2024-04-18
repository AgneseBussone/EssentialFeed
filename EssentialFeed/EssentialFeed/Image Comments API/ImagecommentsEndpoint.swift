//

import Foundation

public enum ImageCommentsEndpoint {
    case get(UUID)

    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(imageId):
            return baseURL.appendingPathComponent("/v1/image/\(imageId.uuidString)/comments")
        }
    }
}
