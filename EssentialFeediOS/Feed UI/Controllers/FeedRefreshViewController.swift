// By using the VM, this controller is linked only to framework dependencies,
// like UIKit, not core logic component from EssentialFeed.

import UIKit

final public class FeedRefreshViewController: NSObject, FeedLoadingView {
    public lazy var view: UIRefreshControl = loadView()

    private let loadFeed: () -> Void
        
    init(loadFeed: @escaping () -> Void) {
        self.loadFeed = loadFeed
    }
        
    @objc func refresh() {
        loadFeed()
    }
    
    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }
    
    private func loadView() -> UIRefreshControl{
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
