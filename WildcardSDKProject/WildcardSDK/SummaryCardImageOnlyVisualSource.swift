//
//  SummaryCardImageOnlyVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 2/6/15.
//
//

import Foundation


public class SummaryCardImageOnlyVisualSource : BaseVisualSource, CardViewVisualSource
{
    var header:ImageOnlyBody!
    var body:FullCardHeader!
    var footer:ViewOnWebCardFooter!
    var aspectRatio:CGFloat
    
    public init(card:Card, aspectRatio:CGFloat){
        self.aspectRatio = aspectRatio
        super.init(card: card)
    }
    
    @objc public func viewForCardHeader()->CardViewElement?{
        if(header == nil){
            header = CardViewElementFactory.createCardViewElement(.ImageOnly) as! ImageOnlyBody
            header.contentEdgeInset = UIEdgeInsetsMake(0, 0, 0, 0)
            header.imageAspectRatio = aspectRatio
        }
        return header
    }
    
    @objc public func viewForCardBody()->CardViewElement{
        if(body == nil){
            body = CardViewElementFactory.createCardViewElement(.FullHeader) as! FullCardHeader
            body.contentEdgeInset = UIEdgeInsetsMake(15, 15, 0, 15)
            body.logo.hidden = true
            body.hairline.hidden = true
        }
        return body
    }
    
    @objc public func viewForCardFooter() -> CardViewElement? {
        if(footer == nil){
            footer = CardViewElementFactory.createCardViewElement(WCElementType.ViewOnWebFooter) as! ViewOnWebCardFooter
            footer.hairline.hidden = true
            footer.contentEdgeInset = UIEdgeInsetsMake(15, 15, 10, 15)
        }
        return footer
    }
}