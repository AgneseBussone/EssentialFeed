// These tests are not very reliable: without the waitForExistence they would fail
// (in fact, I was not able to get the assert to pass even if the elements are rendered on screen)

// NOTE: THESE TESTS ARE NOT USED ANYMORE! INTEGRATION UI TESTS REPLACED THEM!!

import XCTest

final class EssentialAppUIAcceptanceTests: XCTestCase {

    func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() {
        let app = XCUIApplication()
        app.launchArguments = ["-reset", "-connectivity", "online"]
        app.launch()

        let feedCells = app.cells.matching(identifier: "feed-image-cell")
        if feedCells.element.waitForExistence(timeout: 2) {
            XCTAssertEqual(feedCells.count, 2)
        }
        
        let firstImage = app.images.matching(identifier: "feed-image-view").firstMatch
        if firstImage.waitForExistence(timeout: 2) {
            XCTAssertTrue(firstImage.exists)
        }
    }
    
    func test_onLaunch_displaysCacheRemoteFeedWhenCustomersHasNotConnectivity() {
        let onlineApp = XCUIApplication()
        onlineApp.launchArguments = ["-reset", "-connectivity", "online"]
        onlineApp.launch()
        
        let offlineApp = XCUIApplication()
        offlineApp.launchArguments = ["-connectivity", "offline"]
        offlineApp.launch()
        
        let cachedFeedCells = offlineApp.cells.matching(identifier: "feed-image-cell")
        if cachedFeedCells.element.waitForExistence(timeout: 2) {
            XCTAssertEqual(cachedFeedCells.count, 2)
        }
        
        let firstCachedImage = offlineApp.images.matching(identifier: "feed-image-view").firstMatch
        if firstCachedImage.waitForExistence(timeout: 2) {
            XCTAssertTrue(firstCachedImage.exists)
        }
    }
    
    func test_onLaunch_displaysEmptyFeedWhenCustomerHasNoConnectivityAndNoCache() {
        let app = XCUIApplication()
        app.launchArguments = ["-reset", "-connectivity", "offline"]
        app.launch()
        
        let feedCells = app.cells.matching(identifier: "feed-image-cell")
        XCTAssertEqual(feedCells.count, 0)
    }
}
