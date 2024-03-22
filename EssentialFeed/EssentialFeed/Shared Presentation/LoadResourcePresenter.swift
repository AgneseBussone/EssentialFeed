//

import Foundation

public protocol ResourceView {
    func display(_ viewModel: String)
}



public final class LoadResourcePresenter {
    public typealias Mapper = (String) -> String
    
    private let errorView: FeedErrorView
    private let loadingView: FeedLoadingView
    private let resourceView: ResourceView
    private let mapper: Mapper
    
    static var feedLoadError: String {
        return NSLocalizedString("FEED_VIEW_CONNECTION_ERROR", tableName: "Feed", bundle: Bundle(for: FeedPresenter.self), comment: "")
    }

    public init(resourceView: ResourceView, loadingView: FeedLoadingView, errorView: FeedErrorView, mapper: @escaping Mapper) {
        self.errorView = errorView
        self.loadingView = loadingView
        self.resourceView = resourceView
        self.mapper = mapper
    }
    
    public func didStartLoading() {
        errorView.display(.noError)
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoading(with resource: String) {
        resourceView.display(mapper(resource))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
    
    public func didFinishLoadingFeed(with error: Error) {
        loadingView.display(FeedLoadingViewModel(isLoading: false))
        errorView.display(.error(message: FeedPresenter.feedLoadError))
    }
}
