//
//  ImageFullFloatBottomDataSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

public class ImageFullFloatBottomDataSource : CardViewDataSource {
    
    var card:Card
    
    public init(card:Card){
        self.card = card
    }
    
    public func viewForCardHeader()->UIView?{
        return UIView.loadFromNibNamed("FullCardHeader") as? FullCardHeader
    }
    
    public func heightForCardHeader()->CGFloat{
        return FullCardHeader.optimizedHeight(widthForCard(), card: card)
    }
    
    public func viewForCardBody()->UIView{
        return CenteredImageBody(frame:CGRectZero)
    }
    
    public func heightForCardBody()->CGFloat{
        return CenteredImageBody.optimizedHeight(widthForCard(), card: card)
    }
    
    public func viewForCardFooter() -> UIView? {
        return TallReadMoreFooter(frame:CGRectZero)
    }
    
    public func heightForCardFooter() -> CGFloat {
        return TallReadMoreFooter.optimizedHeight(widthForCard(), card: card)
    }
    
    public func viewForBackOfCard()->UIView?{
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