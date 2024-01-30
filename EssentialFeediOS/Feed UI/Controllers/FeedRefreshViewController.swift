// By using the VM, this controller is linked only to framework dependencies,
// like UIKit, not core logic component from EssentialFeed.

import UIKit

protocol FeedRefreshControllerDelegate {
    func didRequestFeedRefresh()
}

final public class FeedRefreshViewController: NSObject, FeedLoadingView {
    @IBOutlet public var view: UIRefreshControl?

    var delegate: FeedRefreshControllerDelegate?
        
    @IBAction func refresh() {
        delegate?.didRequestFeedRefresh()
    }
    
    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view?.beginRefreshing()
        } else {
            view?.endRefreshing()
        }
    }
    
}
