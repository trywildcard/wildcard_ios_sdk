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
        let articleUrl = NSURL(string: "http://www.cnn.com/2014/12/03/justice/new-york-grand-jury-chokehold/index.html")
        Card.getFromUrl(articleUrl!, completion: { (card:Card?, error:NSError?) -> Void in
            XCTAssert(card != nil)
            XCTAssert(error == nil)
            XCTAssert(card?.cardType == "article")
            
            if let articleCard = card as? ArticleCard{
                XCTAssert(true)
                
            }else{
                XCTFail("not article")
            }
            
            expectation.fulfill()
        })
        waitForExpectationsWithTimeout(10, handler:{ error in
        })
    }
    
    func testVideoCard(){
        let expectation = expectationWithDescription("Creates Article Card")
        let articleUrl = NSURL(string: "https://www.youtube.com/watch?v=swZz-QvP7lY")
        Card.getFromUrl(articleUrl!, completion: { (card:Card?, error:NSError?) -> Void in
            XCTAssert(card != nil)
            XCTAssert(error == nil)
            XCTAssert(card?.cardType == "video")
            
            if let articleCard = card as? VideoCard{
                XCTAssert(true)
                
            }else{
                XCTFail("not article")
            }
            
            expectation.fulfill()
        })
        waitForExpectationsWithTimeout(10, handler:{ error in
        })
    }
    
    func testBogusArticleCard(){
        let expectation = expectationWithDescription("Bogus Article Card")
        let articleUrl = NSURL(string: "http://www.badurl.com")
        Card.getFromUrl(articleUrl!, completion: { (card:Card?, error:NSError?) -> Void in
            XCTAssert(card == nil)
            XCTAssert(error != nil)
            expectation.fulfill()
        })
        waitForExpectationsWithTimeout(10, handler:{ error in
        })
    }
    
    func testSummaryCard(){
        let expectation = expectationWithDescription("Bogus Article Card")
        let articleUrl = NSURL(string: "http://www.cnn.com")
        Card.getFromUrl(articleUrl!, completion: { (card:Card?, error:NSError?) -> Void in
            XCTAssert(card != nil)
            XCTAssert(error == nil)
            
            if let summaryCard = card as? SummaryCard{
                XCTAssert(true)
            }else{
                XCTFail("not summary")
            }
            
            expectation.fulfill()
        })
        waitForExpectationsWithTimeout(10, handler:{ error in
        })
    }
    
    func testSummaryCardTryWildcard(){
        let expectation = expectationWithDescription("Bogus Article Card")
        let articleUrl = NSURL(string: "http://www.trywildcard.com")
        Card.getFromUrl(articleUrl!, completion: { (card:Card?, error:NSError?) -> Void in
            XCTAssert(card != nil)
            XCTAssert(error == nil)
            
            if let summaryCard = card as? SummaryCard{
                XCTAssert(true)
                XCTAssert(summaryCard.primaryImageURL != nil)
                XCTAssert(summaryCard.appLinkIos != nil)
            }else{
                XCTFail("not summary")
            }
            
            expectation.fulfill()
        })
        waitForExpectationsWithTimeout(10, handler:{ error in
        })
    }
    
    func testSummaryCardLayouts(){
        let engine = CardLayoutEngine.sharedInstance
        let url = NSURL(string: "http://www.google.com")
        let publisher = Creator(name:"Google", url:url!, favicon:nil, iosStore:nil, androidStore:nil)
        
        let media:NSMutableDictionary = NSMutableDictionary()
        media["imageUrl"] = "http://netdna.webdesignerdepot.com/uploads/2013/02/featured35@wdd2x.jpg"
        media["type"] = "image"
        
        // no image results in default lay out
        let SummaryCard1 = SummaryCard(url: url!, description: "test1", title: "test1", media:nil, data:nil)
        XCTAssert(engine.matchLayout(SummaryCard1) == .SummaryCardNoImage)
        
        let imageUrl = NSURL(string: "http://www.google.com")
       
        // image with short title
        let SummaryCard2 = SummaryCard(url: url!, description: "test2", title: "test2", media:media, data:nil)
        XCTAssert(engine.matchLayout(SummaryCard2) == .SummaryCardTall)
        
        // image with long title and short description
        let SummaryCard3 = SummaryCard(url: url!, description: "test2", title: "longer title generates a different layout", media:media, data:nil)
        XCTAssert(engine.matchLayout(SummaryCard3) == .SummaryCardTall)
        
        // image with long title and long description
        let SummaryCard4 = SummaryCard(url: url!, description: "long description that has to be over 140 characters the quick brown fox jumped over the lazy dog the quick brown fox jumped over the lazy dog", title: "longer title generates a different layout", media:media, data:nil)
        XCTAssert(engine.matchLayout(SummaryCard4) == .SummaryCardTall)
        
    }
    
    func testArticleCardLayouts(){
        let engine = CardLayoutEngine.sharedInstance
        let url = NSURL(string: "http://www.google.com")
        let publisher = Creator(name:"Google", url:url!, favicon:nil, iosStore:nil, androidStore:nil)
        
        // article card no image has default
        let articleCard = ArticleCard(title: "default", abstractContent: "", url: url!, creator:publisher, data:NSDictionary())
        XCTAssert(engine.matchLayout(articleCard) == .ArticleCardNoImage)
        
        let articleCard2 = ArticleCard(title: "The quick brown fox jumped over the lazy dog. The quick brown fox jumped over the dog", abstractContent: "", url: url!, creator:publisher, data:NSDictionary())
        XCTAssert(engine.matchLayout(articleCard2) == .ArticleCardNoImage)
        
        let media:NSMutableDictionary = NSMutableDictionary()
        media["imageUrl"] = "http://www.google.com"
        media["type"] = "image"
        
        let articleData:NSMutableDictionary = NSMutableDictionary()
        articleData["media"] = media
        
        let data:NSMutableDictionary = NSMutableDictionary()
        data["article"] = articleData
        let articleCard3 = ArticleCard(title: "default", abstractContent: "", url: url!, creator:publisher, data:data)
        XCTAssert(engine.matchLayout(articleCard3) == WCCardLayout.ArticleCardTall)
        
    }
    
    func testBasicCardViews(){
        let engine = CardLayoutEngine.sharedInstance
        let url = NSURL(string: "http://www.google.com")
        let publisher = Creator(name:"Google", url:url!, favicon:nil, iosStore:nil, androidStore:nil)
        
        // no image results in default lay out
        let SummaryCard1 = SummaryCard(url: url!, description: "The quick brown fox jumped over the lazy dog. This is a long description.", title: "test1", media:nil, data:nil)
        
        let view1:CardView = CardView.createCardView(SummaryCard1)!
        XCTAssert(view1.frame.origin.x == 0)
        XCTAssert(view1.frame.origin.y == 0)
        XCTAssert(view1.frame.size.width > 0)
        XCTAssert(view1.frame.size.height > 0)
        
        let view2:CardView? = CardView.createCardView(SummaryCard1, layout: WCCardLayout.ArticleCardTall)
        XCTAssert(view2 == nil)
        
        let view3:CardView? = CardView.createCardView(SummaryCard1, layout: WCCardLayout.SummaryCardNoImage, preferredWidth:300)
        XCTAssert(view3 != nil)
        XCTAssert(view3!.frame.size.width  == 300)
        
        let fatterView3:CardView? = CardView.createCardView(SummaryCard1, layout: WCCardLayout.SummaryCardNoImage, preferredWidth:150)
        XCTAssert(fatterView3 != nil)
        XCTAssert(fatterView3!.frame.size.width == 150)
        XCTAssert(fatterView3!.frame.size.height > view3!.frame.size.height)
    }
    
    func testBasicCardViewIntrinsicSizing(){
        let engine = CardLayoutEngine.sharedInstance
        let url = NSURL(string: "http://www.google.com")
        let publisher = Creator(name:"Google", url:url!, favicon:nil, iosStore:nil, androidStore:nil)
        
        // no image results in default lay out
        let SummaryCard1 = SummaryCard(url: url!, description: "The quick brown fox jumped over the lazy dog. This is a long description.", title: "test1", media:nil, data:nil)
        
        let view1:CardView = CardView.createCardView(SummaryCard1)!
        XCTAssert(view1.frame.origin.x == 0)
        XCTAssert(view1.frame.origin.y == 0)
        XCTAssert(view1.frame.size.width > 0)
        XCTAssert(view1.frame.size.height > 0)
        
        XCTAssert(view1.intrinsicContentSize().width > 0)
        
        // adjust width lower
        var currentSize = view1.intrinsicContentSize()
        view1.preferredWidth = view1.preferredWidth - 50
        XCTAssert(view1.intrinsicContentSize().width == (currentSize.width - 50))
    }
    
    
}
