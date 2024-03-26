//

import Foundation
import XCTest
import EssentialFeed

extension FeedUIIntegrationTests {

    private class DummyResourceView: ResourceView {
        func display(_ viewModel: Any) {}
    }
    var loadError: String {
        LoadResourcePresenter<Any, DummyResourceView>.loadError
    }

    var feedTitle: String {
        FeedPresenter.title
    }
}

