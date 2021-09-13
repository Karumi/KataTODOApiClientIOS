import Foundation

extension NSError {
    static func networkError() -> NSError {
        NSError(domain: NSURLErrorDomain,
            code: NSURLErrorNetworkConnectionLost,
            userInfo: nil)
    }
}
