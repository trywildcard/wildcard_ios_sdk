//
//  SummaryCardImageOnlyVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 2/6/15.
//
//

import Foundation

@objc
public class SummaryCardImageOnlyVisualSource : BaseVisualSource, CardViewVisualSource
{
    var header:FullCardHeader!
    var body:ImageOnlyBody!
    var footer:ViewOnWebCardFooter!
    var aspectRatio:CGFloat
    
    public init(card:Card, aspectRatio:CGFloat){
        self.aspectRatio = aspectRatio
        super.init(card: card)
    }
    
    public func viewForCardHeader()->CardViewElement?{
        if(header == nil){
            header = CardViewElementFactory.createCardViewElement(WCElementType.FullHeader) as FullCardHeader
            header.logo.hidden = true
            header.contentEdgeInset = UIEdgeInsetsMake(10, 15, 10, 15)
            header.hairline.hidden = true
        }
        return header
    }
    
    public func viewForCardBody()->CardViewElement{
        if(body == nil){
            body = CardViewElementFactory.createCardViewElement(WCElementType.ImageOnly) as ImageOnlyBody
            body.contentEdgeInset = UIEdgeInsetsMake(0, 15, 5, 15)
            body.imageAspectRatio = aspectRatio
        }
        return body
    }
    
    public func viewForCardFooter() -> CardViewElement? {
        if(footer == nil){
            footer = CardViewElementFactory.createCardViewElement(WCElementType.ViewOnWebFooter) as ViewOnWebCardFooter
            footer.hairline.hidden = true
        }
        return footer
    }
}