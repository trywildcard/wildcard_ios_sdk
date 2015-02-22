//
//  SummaryCardLandscapeImageVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/24/15.
//
//

import Foundation

@objc
public class SummaryCardShortVisualSource : BaseVisualSource, CardViewVisualSource
{
    var header:FullCardHeader!
    var body:ImageFloatRightBody!
    var footer:ViewOnWebCardFooter!
    
    public func viewForCardHeader()->CardViewElement?{
        if(header == nil){
            header = CardViewElementFactory.createCardViewElement(WCElementType.FullHeader) as FullCardHeader
            header.hairline.hidden = true
        }
        return header
    }
    
    public func viewForCardBody()->CardViewElement{
        if(body == nil){
            body = CardViewElementFactory.createCardViewElement(WCElementType.ImageFloatRight) as ImageFloatRightBody
            body.contentEdgeInset = UIEdgeInsetsMake(5, 15, 5, 15)
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