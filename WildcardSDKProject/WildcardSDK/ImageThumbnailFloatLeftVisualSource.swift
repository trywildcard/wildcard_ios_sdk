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
    var body:ImageThumbnailFloatLeft
    var footer:ViewOnWebCardFooter
    
    public init(card:Card){
        self.card = card
        self.body = UIView.loadFromNibNamed("ImageThumbnailFloatLeft") as ImageThumbnailFloatLeft
        self.footer = ViewOnWebCardFooter(frame:CGRectZero)
    }
    
    public func viewForCardBody()->CardViewElement{
        return body
    }
    
    public func heightForCardBody()->CGFloat{
        return body.optimizedHeight(widthForCard())
    }
    
    public func viewForCardFooter()->CardViewElement?{
        return footer
    }
    
    public func heightForCardFooter()->CGFloat{
        return footer.optimizedHeight(widthForCard())
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