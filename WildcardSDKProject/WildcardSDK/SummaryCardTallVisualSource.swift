//
//  SummaryCardFullImageVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/18/15.
//
//

import Foundation


public class SummaryCardTallVisualSource : BaseVisualSource, CardViewVisualSource {
    
    var header:FullCardHeader!
    var body:ImageAndCaptionBody!
    var footer:ViewOnWebCardFooter!
    var aspectRatio:CGFloat
    
    public init(card:Card, aspectRatio:CGFloat){
        self.aspectRatio = aspectRatio
        super.init(card: card)
    }
    
    @objc public func viewForCardHeader()->CardViewElement?{
        if(header == nil){
            header = CardViewElementFactory.createCardViewElement(WCElementType.FullHeader) as! FullCardHeader
            header.hairline.hidden = true
            header.logo.hidden = true
            header.contentEdgeInset = UIEdgeInsetsMake(10, 15, 10, 15)
        }
        return header
    }
    
    @objc public func viewForCardBody()->CardViewElement{
        if(body == nil){
            body = CardViewElementFactory.createCardViewElement(WCElementType.ImageAndCaption) as! ImageAndCaptionBody
            body.contentEdgeInset = UIEdgeInsetsMake(0, 15, 5, 15)
            body.imageAspectRatio = aspectRatio
        }
        return body
    }
    
    @objc public func viewForCardFooter() -> CardViewElement? {
        if(footer == nil){
            self.footer = CardViewElementFactory.createCardViewElement(WCElementType.ViewOnWebFooter) as! ViewOnWebCardFooter
            self.footer.hairline.hidden = true
        }
        return footer
    }
}