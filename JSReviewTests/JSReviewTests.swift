//
//  JSReviewTests.swift
//  JSReviewTests
//
//  Created by Jean Sandrin on 4/23/18.
//  Copyright © 2018 JeanSandrin. All rights reserved.
//

import XCTest
@testable import JSReview

class JSReviewTests: XCTestCase {
    
    var jsReview: JSReview!
    let appID: String = "APPID"
    let locale: Locale = Locale(identifier: "en")
    var expectation: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
        jsReview = JSReview(appID: appID,
                            developmentMode: true,
                            daysUntilRequest: 15,
                            daysUntilRemember: 15,
                            locale: locale)
    }
    
    override func tearDown() {
        super.tearDown()
        for (key, _) in jsReview.userDefaults.dictionaryRepresentation() {
            jsReview.userDefaults.removeObject(forKey: key)
        }
    }
    
    func testGetsCorrectString() {
        XCTAssertEqual(jsReview.alertMessage, "Are you enjoying the app? Give us a Review")
        XCTAssertEqual(jsReview.alertTitle, "Review")
        XCTAssertEqual(jsReview.reviewActionTitle, "Sure")
        XCTAssertEqual(jsReview.rememberLaterActionTitle, "Remember me later")
        XCTAssertEqual(jsReview.forgetActionTitle, "Don't remember me again")
    }
    
    func testStoresValues() {
        let review = JSReview(appID: appID)
        XCTAssertEqual(review.daysUntilRequest, 15)
        XCTAssertEqual(review.daysUntilRemember, 15)
        XCTAssertEqual(review.appID, appID)
        XCTAssertTrue(review.isDevelopmentMode)
    }
    
    func testSetsIsFirstUse() {
        XCTAssertTrue(jsReview.isFirstUse)
        jsReview.isFirstUse = false
        XCTAssertFalse(jsReview.isFirstUse)
    }
    
    func testSetsInitialDate() {
        XCTAssertTrue(jsReview.isFirstUse)
        XCTAssertNotNil(jsReview.userDefaults.value(forKey: jsReview.identifierLastRemidedDate) as! Date)
    }
    
    func testAsksUseToReviewInDevelopmentMode() {
        expectation = expectation(description: "should present aletrt and complete with success")

        let controller = MockController()
        jsReview.askToReview(on: controller) { (present) in
            XCTAssertTrue(present)
            self.expectation?.fulfill()
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testShouldAskToReview_FirstTime() {
        expectation = expectation(description: "should present aletrt and complete with success")
        jsReview.userDefaults.set(Date().addingTimeInterval(-(24 * 60 * 60 * 20)), forKey: jsReview.identifierLastRemidedDate)
        jsReview.isFirstUse = true
        jsReview.isDevelopmentMode = false
        let controller = MockController()
        jsReview.askToReview(on: controller) { (present) in
            XCTAssertTrue(present)
            self.expectation?.fulfill()
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testShouldAskToReview_Reminder() {
        expectation = expectation(description: "should present aletrt and complete with success")
        jsReview.userDefaults.set(Date().addingTimeInterval(-(24 * 60 * 60 * 20)), forKey: jsReview.identifierLastRemidedDate)
        jsReview.isFirstUse = false
        jsReview.isDevelopmentMode = false
        let controller = MockController()
        jsReview.askToReview(on: controller) { (present) in
            XCTAssertTrue(present)
            self.expectation?.fulfill()
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testShouldNotAskToReview_firstTime() {
        expectation = expectation(description: "should present aletrt and complete with success")
        jsReview.userDefaults.set(Date().addingTimeInterval(-(24 * 60 * 60 * 10)), forKey: jsReview.identifierLastRemidedDate)
        jsReview.isFirstUse = true
        jsReview.isDevelopmentMode = false
        let controller = MockController()
        jsReview.askToReview(on: controller) { (present) in
            XCTAssertFalse(present)
            self.expectation?.fulfill()
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testShouldNotAskToReview_Reminder() {
        expectation = expectation(description: "should present aletrt and complete with success")
        jsReview.userDefaults.set(Date().addingTimeInterval(-(24 * 60 * 60 * 10)), forKey: jsReview.identifierLastRemidedDate)
        jsReview.isFirstUse = false
        jsReview.isDevelopmentMode = false
        let controller = MockController()
        jsReview.askToReview(on: controller) { (present) in
            XCTAssertFalse(present)
            self.expectation?.fulfill()
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testShouldNotAsktoReview_Reviewed() {
        expectation = expectation(description: "should present aletrt and complete with success")
        jsReview.userDefaults.set(Date().addingTimeInterval(-(24 * 60 * 60 * 20)), forKey: jsReview.identifierLastRemidedDate)
        jsReview.isFirstUse = false
        jsReview.isDevelopmentMode = false
        jsReview.reviewed = true
        let controller = MockController()
        jsReview.askToReview(on: controller) { (present) in
            XCTAssertFalse(present)
            self.expectation?.fulfill()
        }
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testReview() {
        jsReview.urlOpener = MockURLOpener()
        jsReview.review(appID)
        XCTAssertTrue(jsReview.reviewed)
    }
    
    func testRememberLater() {
        jsReview.rememberLater()
        XCTAssertFalse(jsReview.reviewed)
        XCTAssertFalse(jsReview.isFirstUse)
    }
    
    func testCreateALertToReview() {
        let alert = jsReview.alertToReview()
        XCTAssertEqual(alert.actions.count, 3)
        var action = alert.actions[0]
        XCTAssertEqual(action.title!, "Sure")
        action = alert.actions[1]
        XCTAssertEqual(action.title, "Remember me later")
        action = alert.actions[2]
        XCTAssertEqual(alert.title!, "Review")
    }
}

fileprivate struct MockURLOpener: URLOpenerInterface {
    var expectation: XCTestExpectation?
    mutating func open(_ url: URL) {
        XCTAssertEqual(URL(string: "itms-apps:itunes.apple.com/app/APPID?mt=8&action=write-review")!, url)
    }
}

fileprivate final class MockController: UIViewController {
    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        XCTAssertNotNil(completion)
        XCTAssertTrue(flag)
        XCTAssertNotNil(viewControllerToPresent as? UIAlertController)
        completion?()
    }
}
