//
//  WildcardSDKExtensionTests.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 4/23/15.
//
//

import UIKit
import XCTest
import WildcardSDK

class WildcardSDKExtensionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTwitterProfileURL() {
        var url:NSURL?
        url = NSURL(string: "https://www.twitter.com/maxbulger")
        XCTAssert(url?.isTwitterProfileURL() == true)
        url = NSURL(string: "https://www.twitter.com/maxbulger/")
        XCTAssert(url?.isTwitterProfileURL() == true)
        url = NSURL(string: "https://www.twitter.com/maxbulger/status/23234234/")
        XCTAssert(url?.isTwitterProfileURL() == false)
        url = NSURL(string: "https://www.facebook.com/maxbulger")
        XCTAssert(url?.isTwitterProfileURL() == false)
        url = NSURL(string: "https://www.facebook.com/maxbulger/asdfa/asdfa")
        XCTAssert(url?.isTwitterProfileURL() == false)
        url = NSURL(string: "https://twitter.com/NateChaseH")
        XCTAssert(url?.isTwitterProfileURL() == true)
        url = NSURL(string: "https://twitter.com/maxbulger")
        XCTAssert(url?.isTwitterProfileURL() == true)
        url = NSURL(string: "https://twitter.com/maxbulger/")
        XCTAssert(url?.isTwitterProfileURL() == true)
        url = NSURL(string: "https://twitter.com/maxbulger/status/23234234/")
        XCTAssert(url?.isTwitterProfileURL() == false)
    }
    
    func testTwitterTweetURL(){
        var url:NSURL?
        url = NSURL(string: "https://www.twitter.com/maxbulger")
        XCTAssert(url?.isTwitterTweetURL() == false)
        url = NSURL(string: "https://www.twitter.com/maxbulger/")
        XCTAssert(url?.isTwitterTweetURL() == false)
        url = NSURL(string: "https://www.twitter.com/maxbulger/status/23234234/")
        XCTAssert(url?.isTwitterTweetURL() == true)
        url = NSURL(string: "https://www.twitter.com/maxbulger/status/23234234")
        XCTAssert(url?.isTwitterTweetURL() == true)
        url = NSURL(string: "https://www.facebook.com/maxbulger")
        XCTAssert(url?.isTwitterTweetURL() == false)
        url = NSURL(string: "https://www.facebook.com/maxbulger/asdfa/asdfa")
        XCTAssert(url?.isTwitterTweetURL() == false)
        url = NSURL(string: "https://www.facebook.com/maxbulger/status/notnumbers")
        XCTAssert(url?.isTwitterTweetURL() == false)
        url = NSURL(string: "https://www.facebook.com/maxbulger/status/notnumbers/")
        XCTAssert(url?.isTwitterTweetURL() == false)
        url = NSURL(string: "https://twitter.com/maxbulger")
        XCTAssert(url?.isTwitterTweetURL() == false)
        url = NSURL(string: "https://twitter.com/maxbulger/")
        XCTAssert(url?.isTwitterTweetURL() == false)
        url = NSURL(string: "https://twitter.com/maxbulger/status/23234234/")
        XCTAssert(url?.isTwitterTweetURL() == true)
        url = NSURL(string: "https://twitter.com/maxbulger/status/23234234")
        XCTAssert(url?.isTwitterTweetURL() == true)
        url = NSURL(string: "https://facebook.com/maxbulger")
        XCTAssert(url?.isTwitterTweetURL() == false)
        url = NSURL(string: "https://facebook.com/maxbulger/asdfa/asdfa")
        XCTAssert(url?.isTwitterTweetURL() == false)
        url = NSURL(string: "https://facebook.com/maxbulger/status/notnumbers")
        XCTAssert(url?.isTwitterTweetURL() == false)
        url = NSURL(string: "https://facebook.com/maxbulger/status/notnumbers/")
        XCTAssert(url?.isTwitterTweetURL() == false)
        
    }

}
