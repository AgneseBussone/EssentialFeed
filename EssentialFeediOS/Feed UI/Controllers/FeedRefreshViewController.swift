//

import UIKit
import EssentialFeed

final public class FeedRefreshViewController: NSObject {
    
    private let feedLoader: FeedLoader
    
    var onRefresh: (([FeedImage]) -> Void)?
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    public lazy var view: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()
    
    @objc func refresh() {
        view.beginRefreshing()
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onRefresh?(feed)
            }
            self?.view.endRefreshing()
        }
    }
}
