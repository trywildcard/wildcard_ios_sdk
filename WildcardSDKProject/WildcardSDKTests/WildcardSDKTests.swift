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
        WebLinkCard.createFromWebUrl(articleUrl!, completion: { (card:WebLinkCard?, error:NSError?) -> Void in
            XCTAssert(card != nil)
            XCTAssert(error == nil)
            expectation.fulfill()
        })
        waitForExpectationsWithTimeout(10, handler:{ error in
        })
    }
    
    func testWebLinkCardLayouts(){
        let engine = CardLayoutEngine.sharedInstance
        let url = NSURL(string: "http://www.google.com")
        
        let articleCard = ArticleCard(title: "default", html: "", url: url!, dictionary: nil)
        XCTAssert(engine.matchLayout(articleCard) == CardLayout.BareCard)
        
        // no image results in default lay out
        let webLinkCard1 = WebLinkCard(url: url!, description: "test1", title: "test1", dictionary: nil)
        XCTAssert(engine.matchLayout(webLinkCard1) == CardLayout.LinkCardPortraitDefault)
        
        let testDictionary:NSMutableDictionary = NSMutableDictionary()
        testDictionary["primaryImageUrl"] = "http://www.google.com"
        
        // image with short title
        let webLinkCard2 = WebLinkCard(url: url!, description: "test2", title: "test2", dictionary: testDictionary)
        XCTAssert(engine.matchLayout(webLinkCard2) == CardLayout.LinkCardPortraitImageFull)
        
        // image with long title and short description
        let webLinkCard3 = WebLinkCard(url: url!, description: "test2", title: "longer title generates a different layout", dictionary: testDictionary)
        XCTAssert(engine.matchLayout(webLinkCard3) == CardLayout.LinkCardPortraitImageSmallFloatLeft)
        
        // image with long title and long description
        let webLinkCard4 = WebLinkCard(url: url!, description: "long description that has to be over 140 characters the quick brown fox jumped over the lazy dog the quick brown fox jumped over the lazy dog", title: "longer title generates a different layout", dictionary: testDictionary)
        XCTAssert(engine.matchLayout(webLinkCard4) == CardLayout.LinkCardPortraitImageSmallFloatBottom)
    }
    
    
}
