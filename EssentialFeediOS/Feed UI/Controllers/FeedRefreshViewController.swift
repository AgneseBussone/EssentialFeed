// By using the VM, this controller is linked only to framework dependencies,
// like UIKit, not core logic component from EssentialFeed.
// The communication with the core component is grouped in the FeedViewModel.

import UIKit

final public class FeedRefreshViewController: NSObject {
    
    private let viewModel: FeedViewModel
        
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }
    
    public lazy var view: UIRefreshControl = binded(UIRefreshControl())
    
    @objc func refresh() {
        viewModel.loadFeed()
    }
    
    private func binded(_ view: UIRefreshControl) -> UIRefreshControl{
        viewModel.onLoadingStateChange = { [weak self] isLoading in
            if isLoading {
                self?.view.beginRefreshing()
            } else {
                self?.view.endRefreshing()
            }
        }
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        return view
    }
}
