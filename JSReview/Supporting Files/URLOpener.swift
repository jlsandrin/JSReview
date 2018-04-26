import Foundation

public protocol URLOpenerInterface {
    mutating func open(_ url: URL)
}

/// URLOpener is a wrapper to check and open URLs
public struct URLOpener: URLOpenerInterface {
    public init() { }
    
    private lazy var app: UIApplication = .shared
    
    /// Verifies if URL can be opened and open it
    /// - parameter url: URL to be opened
    mutating public func open(_ url: URL) {
        if !canOpen(url) {
            return
        }
        if #available(iOS 10, *) {
            app.open(url,
                     options: [:],
                     completionHandler: nil)
        } else {
            app.openURL(url)
        }
    }
    
    /// Verifies if url can be opened
    /// - parameter url: URL to check
    public mutating func canOpen(_ url: URL) -> Bool {
        return app.canOpenURL(url)
    }
}
