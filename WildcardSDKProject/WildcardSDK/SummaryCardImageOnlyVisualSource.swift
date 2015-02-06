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
    var header:FullCardHeader
    var body:ImageOnlyBody
    var footer:ViewOnWebCardFooter
    var aspectRatio:CGFloat
    
    public init(card:Card, aspectRatio:CGFloat){
        self.aspectRatio = aspectRatio
        self.header = UIView.loadFromNibNamed("FullCardHeader") as FullCardHeader
        self.header.hairline.hidden = true
        self.body = ImageOnlyBody(frame:CGRectZero)
        self.body.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 5, 15)
        self.body.imageAspectRatio = aspectRatio
        self.footer = ViewOnWebCardFooter(frame:CGRectZero)
        self.footer.hairline.hidden = true
        super.init(card: card)
    }
    
    public func viewForCardHeader()->CardViewElement?{
        return header
    }
    
    public func heightForCardHeader()->CGFloat{
        return header.optimizedHeight(widthForCard())
    }
    
    public func viewForCardBody()->CardViewElement{
        return body
    }
    
    public func heightForCardBody()->CGFloat{
        return body.optimizedHeight(widthForCard())
    }
    
    public func viewForCardFooter() -> CardViewElement? {
        return footer
    }
    
    public func heightForCardFooter() -> CGFloat {
        return footer.optimizedHeight(widthForCard())
    }
    
    public override func widthForCard() -> CGFloat {
        return super.widthForCard();
    }
    
}