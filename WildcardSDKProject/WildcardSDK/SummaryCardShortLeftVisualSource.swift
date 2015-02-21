//
//  SummaryCardShortLeftVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 2/20/15.
//
//

import Foundation


@objc
public class SummaryCardShortLeftVisualSource : BaseVisualSource, CardViewVisualSource
{
    var header:FullCardHeader!
    var body:ImageFloatLeftBody!
    var footer:ViewOnWebCardFooter!
    
    public override init(card:Card){
        super.init(card: card)
    }
    
    public func viewForCardHeader()->CardViewElement?{
        if(header == nil){
            self.header = CardViewElementFactory.createCardViewElement(WCElementType.FullHeader, preferredWidth:widthForCard()) as FullCardHeader
            self.header.hairline.hidden = true
        }
        return header
    }
    
    public func viewForCardBody()->CardViewElement{
        if(body == nil){
            self.body = CardViewElementFactory.createCardViewElement(WCElementType.ImageFloatLeft, preferredWidth:widthForCard()) as ImageFloatLeftBody
            self.body.contentEdgeInset = UIEdgeInsetsMake(5, 15, 5, 15)
        }
        return body
    }
    
    public func viewForCardFooter() -> CardViewElement? {
        if(footer == nil){
            self.footer = CardViewElementFactory.createCardViewElement(WCElementType.ViewOnWebFooter, preferredWidth:widthForCard()) as ViewOnWebCardFooter
            self.footer.hairline.hidden = true
        }
        return footer
    }
}