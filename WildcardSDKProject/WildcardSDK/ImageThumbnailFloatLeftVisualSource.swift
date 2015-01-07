//
//  ImageThumbnailFloatLeftDataSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

public class ImageThumbnailFloatLeftVisualSource : CardViewVisualSource {
    
    var card:Card
    
    public init(card:Card){
        self.card = card
    }
    
    public func viewForCardBody()->CardViewElement{
        return UIView.loadFromNibNamed("ImageThumbnailFloatLeft") as ImageThumbnailFloatLeft
    }
    
    public func heightForCardBody()->CGFloat{
        return ImageThumbnailFloatLeft.optimizedHeight(widthForCard(), card: card)
    }
    
    public func viewForCardFooter()->CardViewElement?{
        return ViewOnWebCardFooter(frame:CGRectZero)
    }
    
    public func heightForCardFooter()->CGFloat{
        return ViewOnWebCardFooter.optimizedHeight(widthForCard(), card: card)
    }
    
    public func viewForBackOfCard()->CardViewElement?{
        return EmptyCardBack(frame:CGRectZero)
    }
    
    public func widthForCard()->CGFloat{
        let screenBounds = UIScreen.mainScreen().bounds
        let defaultMargins:CGFloat = 15.0
        let cardWidth = screenBounds.width - (2*defaultMargins)
        return cardWidth
    }
    
    public func backingCard() -> Card {
        return card
    }
}