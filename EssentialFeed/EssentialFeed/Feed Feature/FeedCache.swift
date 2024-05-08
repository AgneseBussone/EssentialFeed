//

import Foundation

public protocol FeedCache {
    func save(_ items: [FeedImage]) throws
}
