//
//  CardViewVisualSourceFactory.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

class CardViewVisualSourceFactory {
    
    /// Returns a stock visual source from a given card layout. If width is specified, we'll use the override width
    class func visualSourceFromLayout(layout:WCCardLayout, card:Card, width:CGFloat?)->CardViewVisualSource{
        switch(layout){
        case .SummaryCardNoImage:
            var source = SummaryCardNoImageVisualSource(card:card)
            source.preferredWidth = width
            return source
        case .SummaryCardShort:
            var source = SummaryCardShortVisualSource(card:card)
            source.preferredWidth = width
            return source
        case .SummaryCardShortLeft:
            var source = SummaryCardShortLeftVisualSource(card:card)
            source.preferredWidth = width
            return source
        case .SummaryCardTall:
            var source = SummaryCardFullImageVisualSource(card:card,aspectRatio:0.75)
            source.preferredWidth = width
            return source
        case .SummaryCardImageOnly:
            var source = SummaryCardImageOnlyVisualSource(card:card,aspectRatio:0.75)
            source.preferredWidth = width
            return source
        case .ArticleCardNoImage:
            var source = ArticleCardNoImageVisualSource(card:card)
            source.preferredWidth = width
            return source
        case .ArticleCardTall:
            var source = ArticleCardFullImageVisualSource(card:card, aspectRatio: 0.75)
            source.preferredWidth = width
            return source
        case .ArticleCardShort:
            var source = ArticleCardSmallImageVisualSource(card:card)
            source.preferredWidth = width
            return source
        case .Unknown:
            // shouldn't happen
            var source = SummaryCardNoImageVisualSource(card:card)
            source.preferredWidth = width
            return source
        }
    }
    
    class func visualSourceFromLayout(layout:WCCardLayout, card:Card)->CardViewVisualSource{
        return CardViewVisualSourceFactory.visualSourceFromLayout(layout, card: card, width: nil)
    }
}