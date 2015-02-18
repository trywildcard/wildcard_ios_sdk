//
//  SummaryCardNoImageVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/18/15.
//
//

import Foundation

@objc
public class SummaryCardNoImageVisualSource : BaseVisualSource, CardViewVisualSource{
    
    var header:FullCardHeader!
    var body:SingleParagraphCardBody!
    var footer:ViewOnWebCardFooter!
    
    public override init(card:Card){
        super.init(card:card)
    }
    
    public func viewForCardHeader()->CardViewElement?{
        if(header == nil){
            header = CardViewElementFactory.createCardViewElement(WCElementType.FullHeader, preferredWidth:widthForCard()) as FullCardHeader
            header.hairline.hidden = true
            header.logo.hidden = true
            header.contentEdgeInset = UIEdgeInsetsMake(10, 15, 10, 15)
        }
        return header
    }
    
    public func heightForCardHeader()->CGFloat{
        return header.optimizedHeight(widthForCard())
    }
    
    public func viewForCardBody()->CardViewElement{
        if(body == nil){
            body = CardViewElementFactory.createCardViewElement(WCElementType.SimpleParagraph, preferredWidth:widthForCard()) as SingleParagraphCardBody
            body.contentEdgeInset = UIEdgeInsetsMake(0, 15, 5, 15)
        }
        return body;
    }
    
    public func heightForCardBody()->CGFloat{
        return body.optimizedHeight(widthForCard())
    }
    
    public func viewForCardFooter()->CardViewElement?{
        if(footer == nil){
            footer = CardViewElementFactory.createCardViewElement(WCElementType.ViewOnWebFooter, preferredWidth:widthForCard()) as ViewOnWebCardFooter
            footer.hairline.hidden = true
        }
        return footer
    }
    
    public func heightForCardFooter()->CGFloat{
        return footer.optimizedHeight(widthForCard())
    }
    
    public override func widthForCard() -> CGFloat {
        return super.widthForCard();
    }
}