//
//  SummaryCard4x3FloatRightImageTextWrapVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/18/15.
//
//

import Foundation

public class SummaryCard4x3FloatRightImageTextWrapVisualSource: CardViewVisualSource
{
    var card:Card
    var header:FullCardHeader
    var body:MediaTextImageFloatRight
    var footer:ViewOnWebCardFooter
    
    public init(card:Card){
        self.card = card
        self.body = UIView.loadFromNibNamed("MediaTextImageFloatRight") as MediaTextImageFloatRight
        self.header = UIView.loadFromNibNamed("FullCardHeader") as FullCardHeader
        self.footer = ViewOnWebCardFooter(frame:CGRectZero)
        
        self.body.textContainerEdgeInsets = UIEdgeInsetsMake(5, 10, 0, 10)
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
        return widthForCard() - heightForCardFooter() - heightForCardHeader()   
    }
    
    public func viewForCardFooter() -> CardViewElement? {
        return footer
    }
    
    public func heightForCardFooter() -> CGFloat {
        return footer.optimizedHeight(widthForCard())
    }
    
    public func widthForCard()->CGFloat{
        let screenBounds = UIScreen.mainScreen().bounds
        let defaultMargins:CGFloat = 15.0
        let cardWidth = screenBounds.width - (2*defaultMargins)
        return cardWidth
    }
    
}