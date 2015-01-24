//
//  ArticleCard4x3FloatRightImageTextWrapVisualSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 1/18/15.
//
//

import Foundation

public class ArticleCard4x3FloatRightImageTextWrapVisualSource : CardViewVisualSource
{
    var card:Card
    var header:FullCardHeader
    var body:MediaTextImageFloatRight
    var footer:ReadMoreFooter
    
    public init(card:Card){
        self.card = card
        self.header = UIView.loadFromNibNamed("FullCardHeader") as FullCardHeader
        self.header.hairline.hidden = true
        self.header.titleOffset = UIOffsetMake(15, self.header.titleOffset.vertical)
        self.body = UIView.loadFromNibNamed("MediaTextImageFloatRight") as MediaTextImageFloatRight
        self.body.textContainerEdgeInsets = UIEdgeInsetsMake(5, 15, 0, 15)
        self.footer = ReadMoreFooter(frame:CGRectZero)
        self.footer.readMoreButtonOffset = UIOffsetMake(15, 0)
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
        // keeping it square
        return widthForCard() - heightForCardFooter() - heightForCardHeader()
    }
    
    public func viewForBackOfCard()->CardViewElement?{
        return EmptyCardBack(frame:CGRectZero)
    }
    
    public func viewForCardFooter() -> CardViewElement? {
        return footer
    }
    
    public func heightForCardFooter() -> CGFloat {
        return 60
    }
    
    public func widthForCard()->CGFloat{
        // always a square, landscape or not
        let screenBounds = UIScreen.mainScreen().bounds
        if(screenBounds.width > screenBounds.height){
            return screenBounds.height - (2 * WildcardSDK.cardScreenMargin)
        }else{
            return screenBounds.width - (2 * WildcardSDK.cardScreenMargin)
        }
    }
}