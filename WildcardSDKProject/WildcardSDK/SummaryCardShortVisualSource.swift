//
//  SummaryCardLandscapeImageVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/24/15.
//
//

import Foundation


public class SummaryCardShortVisualSource : BaseVisualSource, CardViewVisualSource
{
    var header:FullCardHeader!
    var body:ImageFloatRightBody!
    var footer:ViewOnWebCardFooter!
    
    @objc public func viewForCardHeader()->CardViewElement?{
        if(header == nil){
            header = CardViewElementFactory.createCardViewElement(WCElementType.FullHeader) as! FullCardHeader
            header.logo.hidden = true
            header.hairline.hidden = true
            header.contentEdgeInset = UIEdgeInsetsMake(10, 15, 10, 15)
        }
        return header
    }
    
    @objc public func viewForCardBody()->CardViewElement{
        if(body == nil){
            body = CardViewElementFactory.createCardViewElement(WCElementType.ImageFloatRight) as! ImageFloatRightBody
            body.contentEdgeInset = UIEdgeInsetsMake(5, 15, 5, 15)
        }
        return body
    }
    
    @objc public func viewForCardFooter() -> CardViewElement? {
        if(footer == nil){
            footer = CardViewElementFactory.createCardViewElement(WCElementType.ViewOnWebFooter) as! ViewOnWebCardFooter
            footer.hairline.hidden = true
        }
        return footer
    }
}