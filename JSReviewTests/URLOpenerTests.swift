import XCTest
@testable import JSReview

class URLOpenerTests: XCTestCase {
    
    var urlOpener: URLOpener!
    
    override func setUp() {
        super.setUp()
        urlOpener = URLOpener()
    }
    
    func testCannotOpenURL() {
        XCTAssertFalse(urlOpener.canOpen(URL(fileURLWithPath: "")))
    }
}
