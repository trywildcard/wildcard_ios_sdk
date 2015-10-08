//
//  WildcardSDKElementSizingTests.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 2/19/15.
//
//

import UIKit
import XCTest
import WildcardSDK

class WildcardSDKElementSizingTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHeaderSizing(){
        let header:FullCardHeader = CardViewElementFactory.createCardViewElement(WCElementType.FullHeader) as! FullCardHeader
        header.preferredWidth = 300
        var currentSize:CGSize = header.intrinsicContentSize()
        XCTAssert(currentSize.width == 300)
        
        header.kickerSpacing += 10
        XCTAssert(header.intrinsicContentSize().height > currentSize.height)
        
        header.kickerSpacing -= 10
        print(header.intrinsicContentSize().height)
        XCTAssert(header.intrinsicContentSize().height == currentSize.height)
        currentSize = header.intrinsicContentSize()
        
        // more content inset, large intrinsic size
        var currentInset = header.contentEdgeInset
        header.contentEdgeInset = UIEdgeInsetsMake(currentInset.top + 10, currentInset.left, currentInset.bottom, currentInset.right)
        XCTAssert(header.intrinsicContentSize().height > currentSize.height)
        currentSize = header.intrinsicContentSize()
        
        currentInset = header.contentEdgeInset
        header.contentEdgeInset = UIEdgeInsetsMake(currentInset.top, currentInset.left, currentInset.bottom + 10, currentInset.right)
        XCTAssert(header.intrinsicContentSize().height > currentSize.height)
    }
    
    func testImageCaptionBody(){
        var body:ImageAndCaptionBody = CardViewElementFactory.createCardViewElement(WCElementType.ImageAndCaption) as! ImageAndCaptionBody
        body.preferredWidth = 300
        
        var currentSize:CGSize = body.intrinsicContentSize()
        XCTAssert(currentSize.width == 300)
        
        // aspect ratio changes size
        body.imageAspectRatio = body.imageAspectRatio * 1.1;
        XCTAssert(body.intrinsicContentSize().height > currentSize.height)
        currentSize = body.intrinsicContentSize()
        
        // caption spacing increases height
        body.captionSpacing += 10
        XCTAssert(body.intrinsicContentSize().height > currentSize.height)
        currentSize = body.intrinsicContentSize()
        
        // content inset changes height
        var currentInset = body.contentEdgeInset
        body.contentEdgeInset = UIEdgeInsetsMake(currentInset.top + 10, currentInset.left, currentInset.bottom, currentInset.right)
        XCTAssert(body.intrinsicContentSize().height > currentSize.height)
        currentSize = body.intrinsicContentSize()
        
        // decrease height
        body.captionSpacing -= 5
        XCTAssert(body.intrinsicContentSize().height < currentSize.height)
    }
    
    func testImage(){
        var body:ImageOnlyBody = CardViewElementFactory.createCardViewElement(WCElementType.ImageOnly) as! ImageOnlyBody
        body.preferredWidth = 300
        
        var currentSize:CGSize = body.intrinsicContentSize()
        XCTAssert(currentSize.width == 300)
        
        // aspect ratio changes size
        body.imageAspectRatio = body.imageAspectRatio * 1.1
        XCTAssert(body.intrinsicContentSize().height > currentSize.height)
        currentSize = body.intrinsicContentSize()
        
        body.imageAspectRatio = body.imageAspectRatio * 0.9
        XCTAssert(body.intrinsicContentSize().height < currentSize.height)
        currentSize = body.intrinsicContentSize()
        
        // content inset changes height
        var currentInset = body.contentEdgeInset
        body.contentEdgeInset = UIEdgeInsetsMake(currentInset.top + 10, currentInset.left, currentInset.bottom, currentInset.right)
        XCTAssert(body.intrinsicContentSize().height > currentSize.height)
        currentSize = body.intrinsicContentSize()
        
        body.contentEdgeInset = UIEdgeInsetsMake(currentInset.top, currentInset.left + 10, currentInset.bottom, currentInset.right + 10)
        print(body.intrinsicContentSize().height)
        print(currentSize.height)
        XCTAssert(body.intrinsicContentSize().height < currentSize.height)
    }
    
    func testSingleParagraph(){
        var body:SingleParagraphCardBody = CardViewElementFactory.createCardViewElement(WCElementType.SimpleParagraph) as! SingleParagraphCardBody
        body.preferredWidth = 300
        
        var currentSize:CGSize = body.intrinsicContentSize()
        XCTAssert(currentSize.width == 300)
        
        // content inset changes height
        var currentInset = body.contentEdgeInset
        body.contentEdgeInset = UIEdgeInsetsMake(currentInset.top + 10, currentInset.left, currentInset.bottom, currentInset.right)
        XCTAssert(body.intrinsicContentSize().height > currentSize.height)
        currentSize = body.intrinsicContentSize()
        
        currentInset = body.contentEdgeInset
        body.contentEdgeInset = UIEdgeInsetsMake(currentInset.top, currentInset.left, currentInset.bottom + 5, currentInset.right)
        XCTAssert(body.intrinsicContentSize().height > currentSize.height)
        currentSize = body.intrinsicContentSize()
    }
    
    func testVideoBodySizing(){
        var body:VideoCardBody = CardViewElementFactory.createCardViewElement(WCElementType.VideoBody) as! VideoCardBody
        body.preferredWidth = 300
        
        var currentSize:CGSize = body.intrinsicContentSize()
        XCTAssert(currentSize.width == 300)
        
        // content inset changes height
        var currentInset = body.contentEdgeInset
        body.contentEdgeInset = UIEdgeInsetsMake(currentInset.top + 10, currentInset.left, currentInset.bottom, currentInset.right)
        XCTAssert(body.intrinsicContentSize().height > currentSize.height)
        currentSize = body.intrinsicContentSize()
        
        currentInset = body.contentEdgeInset
        body.contentEdgeInset = UIEdgeInsetsMake(currentInset.top, currentInset.left, currentInset.bottom + 5, currentInset.right)
        XCTAssert(body.intrinsicContentSize().height > currentSize.height)
        currentSize = body.intrinsicContentSize()
    }
    
    

}
