//

import Foundation

public protocol FeedCache {
    typealias SaveResult = Result<Void, Error>

    func save(_ items: [FeedImage], completion: @escaping (SaveResult) -> Void)
}
