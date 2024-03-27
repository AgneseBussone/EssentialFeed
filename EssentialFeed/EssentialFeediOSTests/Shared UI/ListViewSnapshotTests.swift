//

import XCTest
import EssentialFeediOS
@testable import EssentialFeed

final class ListViewSnapshotTests: XCTestCase {

    func test_emptyList() {
        let sut = makeSUT()
        
        sut.display(emptyList())
        
        assert(snapshot: sut.snapshot(for: .iPhone(style: .light)), name: "EMPTY_LIST_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone(style: .dark)), name: "EMPTY_LIST_DARK")
    }
    
    func test_listWithErrorMessage() {
        let sut = makeSUT()
        
        sut.display(.error(message: "This is a \nmultiline\nerror message"))
        
        assert(snapshot: sut.snapshot(for: .iPhone(style: .light)), name: "LIST_WITH_ERROR_MESSAGE_LIGHT")
        assert(snapshot: sut.snapshot(for: .iPhone(style: .dark)), name: "LIST_WITH_ERROR_MESSAGE_DARK")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> ListViewController {
        let controller = ListViewController()
        controller.loadViewIfNeeded()
        controller.tableView.separatorStyle = .none
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }
    
    private func emptyList() -> [CellController] {
        return []
    }

}
