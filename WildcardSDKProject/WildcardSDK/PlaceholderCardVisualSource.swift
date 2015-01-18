//
//  BareBonesCardDataSource.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

public class PlaceholderCardVisualSource : CardViewVisualSource{
    
    var card:Card
    
    public init(card:Card){
        self.card = card
    }
    
    public func viewForCardBody()->CardViewElement{
        return PlaceholderCardBody(frame:CGRectZero)
    }
    
    public func heightForCardBody()->CGFloat{
        // 4 x 3
        return  widthForCard() * (3/4)
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
}