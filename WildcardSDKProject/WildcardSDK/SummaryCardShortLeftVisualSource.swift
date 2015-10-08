//
//  SummaryCardShortLeftVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 2/20/15.
//
//

import Foundation



public class SummaryCardShortLeftVisualSource : BaseVisualSource, CardViewVisualSource
{
    var header:FullCardHeader!
    var body:ImageFloatLeftBody!
    var footer:ViewOnWebCardFooter!
    
    public override init(card:Card){
        super.init(card: card)
    }
    
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
            body = CardViewElementFactory.createCardViewElement(WCElementType.ImageFloatLeft) as! ImageFloatLeftBody
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