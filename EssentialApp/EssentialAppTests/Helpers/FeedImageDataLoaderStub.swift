//

import Foundation
import EssentialFeed

class FeedImageDataLoaderStub: FeedImageDataLoader {
    private let result: FeedImageDataLoader.Result
    
    init(result: FeedImageDataLoader.Result) {
        self.result = result
    }
    
    private class Task: FeedImageDataLoaderTask {
        func cancel() {
        }
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        completion(result)
        return Task()
    }
}
