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
            source.widthOverride = width
            return source
        case .SummaryCard4x3SmallImage:
            var source = SummaryCardSmallImageVisualSource(card:card)
            source.widthOverride = width
            return source
        case .SummaryCard4x3FullImage:
            var source = SummaryCardFullImageVisualSource(card:card,aspectRatio:0.75)
            source.widthOverride = width
            return source
        case .ArticleCardNoImage:
            var source = ArticleCardNoImageVisualSource(card:card)
            source.widthOverride = width
            return source
        case .ArticleCard4x3FullImage:
            var source = ArticleCardFullImageVisualSource(card:card, aspectRatio: 0.75)
            source.widthOverride = width
            return source
        case .ArticleCard4x3SmallImage:
            var source = ArticleCardSmallImageVisualSource(card:card)
            source.widthOverride = width
            return source
        case .Unknown:
            // Shouldn't happen
            return SummaryCardNoImageVisualSource(card:card)
        }
    }
    
    class func visualSourceFromLayout(layout:WCCardLayout, card:Card)->CardViewVisualSource{
        return CardViewVisualSourceFactory.visualSourceFromLayout(layout, card: card, width: nil)
    }
}