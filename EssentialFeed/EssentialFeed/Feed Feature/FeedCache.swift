//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ items: [FeedImage], completion: @escaping (Result) -> Void)
}
