//
//  WildcardSDKTests.swift
//  WildcardSDKTests
//
//  Created by David Xiang on 12/2/14.
//
//

import UIKit
import XCTest
import WildcardSDK

class WildcardSDKTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testArticleCard(){
        let expectation = expectationWithDescription("Creates Article Card")
        let articleUrl = NSURL(string: "http://www.cnn.com/2014/12/03/justice/new-york-grand-jury-chokehold/index.html?hpt=ju_c2")
        ArticleCard.createFromWebUrl(articleUrl!, completion: { (card:ArticleCard?, error:NSError?) -> Void in
            XCTAssert(card != nil)
            XCTAssert(error == nil)
            expectation.fulfill()
        })
        waitForExpectationsWithTimeout(10, handler:{ error in
        })
    }
    
    func testBogusArticleCard(){
        let expectation = expectationWithDescription("Bogus Article Card")
        let articleUrl = NSURL(string: "http://www.google.com")
        ArticleCard.createFromWebUrl(articleUrl!, completion: { (card:ArticleCard?, error:NSError?) -> Void in
            XCTAssert(card == nil)
            XCTAssert(error != nil)
            expectation.fulfill()
        })
        waitForExpectationsWithTimeout(10, handler:{ error in
        })
    }
    
    func testLinkCard(){
        let expectation = expectationWithDescription("Link Card")
        let articleUrl = NSURL(string: "https://www.etsy.com/listing/128235512/etsy-i-buy-from-real-people-tote-bag")
        LinkCard.createFromWebUrl(articleUrl!, completion: { (card:LinkCard?, error:NSError?) -> Void in
            XCTAssert(card != nil)
            XCTAssert(error == nil)
            expectation.fulfill()
        })
        waitForExpectationsWithTimeout(10, handler:{ error in
        })
        
    }
    
    
}
