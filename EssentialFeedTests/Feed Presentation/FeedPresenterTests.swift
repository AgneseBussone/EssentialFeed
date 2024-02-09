//

import XCTest

struct FeedErrorViewModel {
    let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }
}

protocol FeedErrorView {
    func display(_ viewmodel: FeedErrorViewModel)
}

final class FeedPresenter {
    private let errorView: FeedErrorView

    init(errorView: FeedErrorView) {
        self.errorView = errorView

    }
    
    func didStartLoadingFeed() {
        errorView.display(.noError)
    }
}


final class FeedPresenterTests: XCTestCase {

    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_didStartLoadingFeed_displaysNoErrorMessage() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoadingFeed()
        
        XCTAssertEqual(view.messages, [.display(errorMessage: .none)])
    }
    
    // MARK: - Helpers

    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresenter(errorView: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }

    private class ViewSpy: FeedErrorView {
        
        enum Messages: Equatable {
            case display(errorMessage: String?)
        }
        
        private(set) var messages = [Messages]()
        
        func display(_ viewmodel: FeedErrorViewModel) {
            messages.append(.display(errorMessage: viewmodel.message))
        }
    }

}

