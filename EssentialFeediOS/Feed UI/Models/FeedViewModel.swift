//

import Foundation
import EssentialFeed

final class FeedViewModel {
    var onChange: ((FeedViewModel) -> Void)?
    var onFeedLoad: (([FeedImage]) -> Void)?
    private let feedLoader: FeedLoader
    
    private(set) var isLoading: Bool = false {
        didSet { onChange?(self) }
    }
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    func loadFeed() {
        isLoading = true
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onFeedLoad?(feed)
            } else {
                self?.isLoading = false
            }
        }
    }

}
