//

import Foundation
import EssentialFeed

// Retain cycle: the view holds a reference to the presenter and the presenter holds a reference to the view.
// That's why it needs to be weakifyed
protocol FeedLoadingView: AnyObject {
    func display(isLoading: Bool)
}

protocol FeedView {
    func display(feed: [FeedImage])
}

final class FeedPresenter {
    typealias Observer<T> = (T) -> Void
    
    var feedView: FeedView?
    weak var loadingView: FeedLoadingView?
    
    private let feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    func loadFeed() {
        loadingView?.display(isLoading: true)
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.feedView?.display(feed: feed)
            } else {
                self?.loadingView?.display(isLoading: false)
            }
        }
    }

}
