//
//  SummaryCardLandscapeImageVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/24/15.
//
//

import Foundation

@objc
public class SummaryCardSmallImageVisualSource : BaseVisualSource, CardViewVisualSource
{
    var header:FullCardHeader!
    var body:ImageFloatRightBody!
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
    
    public func heightForCardHeader()->CGFloat{
        return header.optimizedHeight(widthForCard())
    }
    
    public func viewForCardBody()->CardViewElement{
        if(body == nil){
            self.body = CardViewElementFactory.createCardViewElement(WCElementType.ImageFloatsRight, preferredWidth:widthForCard()) as ImageFloatRightBody
            self.body.contentEdgeInset = UIEdgeInsetsMake(5, 15, 5, 15)
        }
        return body
    }
    
    public func heightForCardBody()->CGFloat{
        return body.optimizedHeight(widthForCard())
    }
    
    public func viewForCardFooter() -> CardViewElement? {
        if(footer == nil){
            self.footer = CardViewElementFactory.createCardViewElement(WCElementType.ViewOnWebFooter, preferredWidth:widthForCard()) as ViewOnWebCardFooter
            self.footer.hairline.hidden = true
        }
        return footer
    }
    
    public func heightForCardFooter() -> CGFloat {
        return 50
    }
    
    public override func widthForCard() -> CGFloat {
        return super.widthForCard();
    }
    
}