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
            header = CardViewElementFactory.createCardViewElement(WCElementType.FullHeader, preferredWidth:widthForCard()) as FullCardHeader
            header.hairline.hidden = true
        }
        return header
    }
    
    public func heightForCardHeader()->CGFloat{
        return header.optimizedHeight(widthForCard())
    }
    
    public func viewForCardBody()->CardViewElement{
        if(body == nil){
            body = CardViewElementFactory.createCardViewElement(WCElementType.ImageOnly, preferredWidth:widthForCard()) as ImageOnlyBody
            body.contentEdgeInset = UIEdgeInsetsMake(0, 15, 5, 15)
            body.imageAspectRatio = aspectRatio
        }
        return body
    }
    
    public func heightForCardBody()->CGFloat{
        return body.optimizedHeight(widthForCard())
    }
    
    public func viewForCardFooter() -> CardViewElement? {
        if(footer == nil){
            footer = CardViewElementFactory.createCardViewElement(WCElementType.ViewOnWebFooter, preferredWidth:widthForCard()) as ViewOnWebCardFooter
            footer.hairline.hidden = true
        }
        return footer
    }
    
    public func heightForCardFooter() -> CGFloat {
        return footer.optimizedHeight(widthForCard())
    }
    
    public override func widthForCard() -> CGFloat {
        return super.widthForCard();
    }
    
}