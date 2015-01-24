//
//  SummaryCardFullImageVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/18/15.
//
//

import Foundation

public class SummaryCardFullImageVisualSource : CardViewVisualSource {
    
    var card:Card
    var header:FullCardHeader
    var body:ImageAndCaptionBody
    var footer:ViewOnWebCardFooter
    var aspectRatio:CGFloat
    
    public init(card:Card, aspectRatio:CGFloat){
        self.card = card
        self.aspectRatio = aspectRatio
        self.header = UIView.loadFromNibNamed("FullCardHeader") as FullCardHeader
        self.header.hairline.hidden = true
        self.header.titleOffset = UIOffsetMake(15, self.header.titleOffset.vertical)
        self.body = UIView.loadFromNibNamed("ImageAndCaptionBody") as ImageAndCaptionBody
        self.body.contentEdgeInset = UIEdgeInsetsMake(0, 15, 5, 15)
        self.body.imageAspectRatio = aspectRatio
        self.footer = ViewOnWebCardFooter(frame:CGRectZero)
        self.footer.hairline.hidden = true
        self.footer.viewOnWebButtonOffset = UIOffsetMake(15, 0)
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
    
    public func widthForCard()->CGFloat{
        let screenBounds = UIScreen.mainScreen().bounds
        let cardWidth = screenBounds.width - (2 * WildcardSDK.cardScreenMargin)
        return cardWidth
    }
}