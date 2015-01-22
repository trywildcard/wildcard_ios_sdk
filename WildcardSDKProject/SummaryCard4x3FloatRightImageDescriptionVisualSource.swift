//
//  SummaryCard4x3FloatRightImageTextWrapVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/18/15.
//
//

import Foundation

public class SummaryCard4x3FloatRightImageDescriptionVisualSource: CardViewVisualSource
{
    var card:Card
    var header:FullCardHeader
    var body:SingleParagraphCardBody
    var footer:ViewOnWebCardFooter
    
    public init(card:Card){
        self.card = card
        self.body = SingleParagraphCardBody(frame:CGRectZero)
        self.header = UIView.loadFromNibNamed("FullCardHeader") as FullCardHeader
        self.footer = ViewOnWebCardFooter(frame:CGRectZero)
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
        let cardWidth = screenBounds.width - (2 * WildcardSDK.cardHorizontalScreenMargin)
        return cardWidth
    }
    
}