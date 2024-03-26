//

import XCTest
@testable import EssentialFeed

final class SharedLocalizationTests: XCTestCase {
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "SharedStrings"
        let presentationBundle = Bundle(for: LoadResourcePresenter<Any, DummyResourceView>.self)
        assertLocalizedKeyAndValuesExist(in: presentationBundle, table)
    }

}
