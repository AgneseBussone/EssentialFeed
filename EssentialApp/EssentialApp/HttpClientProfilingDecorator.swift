// Example on how to add logging behaviour with Decorator pattern
// See SceneDelegate.makeLocalImageLoaderWithRemoteFallback()

import UIKit
import EssentialFeed
import os

class HttpClientProfilingDecorator: HTTPClient {
    private let decoratee: HTTPClient
    private let logger: Logger
    
    init(decoratee: HTTPClient, logger: Logger) {
        self.decoratee = decoratee
        self.logger = logger
    }
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        logger.trace("Decorator: Started loading url: \(url)")
        
        let startTime = CACurrentMediaTime()
        return decoratee.get(from: url) { [logger] result in
            if case let .failure(error) = result {
                logger.trace("Decorator: Failed to load url: \(url) with error: \(error.localizedDescription)")
            }
            
            let elapsed = CACurrentMediaTime() - startTime
            logger.trace("Decorator: Finished loading url: \(url) in \(elapsed) seconds")
            
            completion(result)
        }
    }
}
