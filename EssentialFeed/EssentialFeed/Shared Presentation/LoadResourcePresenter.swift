//

import Foundation

public final class LoadResourcePresenter {
    private let errorView: FeedErrorView
    private let loadingView: FeedLoadingView
    private let feedView: FeedView
    
    static var feedLoadError: String {
        return NSLocalizedString("FEED_VIEW_CONNECTION_ERROR", tableName: "Feed", bundle: Bundle(for: FeedPresenter.self), comment: "")
    }

    public init(feedView: FeedView, loadingView: FeedLoadingView, errorView: FeedErrorView) {
        self.errorView = errorView
        self.loadingView = loadingView
        self.feedView = feedView
    }
    
    public func didStartLoading() {
        errorView.display(.noError)
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
    
    public func didFinishLoadingFeed(with error: Error) {
        loadingView.display(FeedLoadingViewModel(isLoading: false))
        errorView.display(.error(message: FeedPresenter.feedLoadError))
    }
}
