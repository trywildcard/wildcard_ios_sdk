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
        ArticleCard.createFromUrl(articleUrl!, completion: { (card:ArticleCard?, error:NSError?) -> Void in
            XCTAssert(card != nil)
            XCTAssert(error == nil)
            
            println(card!.publisher.name)
            expectation.fulfill()
        })
        waitForExpectationsWithTimeout(10, handler:{ error in
        })
    }
    
    func testArticleCardLimitSearch(){
        let expectation = expectationWithDescription("Creates Article Card")
        let articleUrl = NSURL(string: "http://www.cnn.com/2014/12/03/justice/new-york-grand-jury-chokehold/index.html?hpt=ju_c2")
        
        ArticleCard.search("isis", limit: 10) { (cards:[ArticleCard]?, error:NSError?) -> Void in
            XCTAssert(cards != nil)
            XCTAssert(error == nil)
            XCTAssert(cards!.count == 10)
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(10, handler:{ error in
        })
    }
    
    func testBogusArticleCard(){
        let expectation = expectationWithDescription("Bogus Article Card")
        let articleUrl = NSURL(string: "http://www.google.com")
        ArticleCard.createFromUrl(articleUrl!, completion: { (card:ArticleCard?, error:NSError?) -> Void in
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
        SummaryCard.createFromUrl(articleUrl!, completion: { (card:SummaryCard?, error:NSError?) -> Void in
            XCTAssert(card != nil)
            XCTAssert(error == nil)
            expectation.fulfill()
        })
        waitForExpectationsWithTimeout(10, handler:{ error in
        })
    }
    
    func testSummaryCardLayouts(){
        let engine = CardLayoutEngine.sharedInstance
        let url = NSURL(string: "http://www.google.com")
        let publisher = Publisher(name:"Google")
        
        let articleCard = ArticleCard(title: "default", html: "", url: url!, publisher:publisher )
        XCTAssert(engine.matchLayout(articleCard) == CardLayout.ArticleCardPortraitNoImage)
        
        // no image results in default lay out
        let SummaryCard1 = SummaryCard(url: url!, description: "test1", title: "test1", imageUrl:nil)
        XCTAssert(engine.matchLayout(SummaryCard1) == CardLayout.SummaryCardPortraitDefault)
        
        let imageUrl = NSURL(string: "http://www.google.com")
       
        // image with short title
        let SummaryCard2 = SummaryCard(url: url!, description: "test2", title: "test2", imageUrl:imageUrl)
        XCTAssert(engine.matchLayout(SummaryCard2) == CardLayout.SummaryCardPortraitImageFull)
        
        // image with long title and short description
        let SummaryCard3 = SummaryCard(url: url!, description: "test2", title: "longer title generates a different layout", imageUrl:imageUrl)
        XCTAssert(engine.matchLayout(SummaryCard3) == CardLayout.SummaryCardPortraitImageSmallFloatLeft)
        
        // image with long title and long description
        let SummaryCard4 = SummaryCard(url: url!, description: "long description that has to be over 140 characters the quick brown fox jumped over the lazy dog the quick brown fox jumped over the lazy dog", title: "longer title generates a different layout", imageUrl:imageUrl)
        XCTAssert(engine.matchLayout(SummaryCard4) == CardLayout.SummaryCardPortraitImageFull)
        
        let longDesc = "Everybody I send cards to this year is getting one of these."
        let SummaryCard5 = SummaryCard(url:url!, description:longDesc, title:longDesc, imageUrl:imageUrl)
        XCTAssert(engine.matchLayout(SummaryCard5) == CardLayout.SummaryCardPortraitImageSmallFloatLeft)
        
    }
    
    func testArticleCardLayouts(){
        let engine = CardLayoutEngine.sharedInstance
        let url = NSURL(string: "http://www.google.com")
        let publisher = Publisher(name:"Google")
        
        // article card no image has default
        let articleCard = ArticleCard(title: "default", html: "", url: url!, publisher:publisher)
        XCTAssert(engine.matchLayout(articleCard) == CardLayout.ArticleCardPortraitNoImage)
    }
    
    func testArticleGeneralSearch(){
        let expectation = expectationWithDescription("General Article")
        ArticleCard.search("isis") { (articleCards:[ArticleCard]?, error:NSError?) -> Void in
            XCTAssert(error == nil)
            XCTAssert(articleCards?.count > 0)
            expectation.fulfill()
        }
 
        waitForExpectationsWithTimeout(10, handler:{ error in
        })
        
    }
    
}
