//
//  CardViewVisualSourceFactory.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

class CardViewVisualSourceFactory {
    
    class func visualSourceFromLayout(layout:WCCardLayout, card:Card)->CardViewVisualSource{
        switch(layout){
        case .SummaryCardNoImage:
            return SummaryCardNoImageVisualSource(card:card)
        case .SummaryCard4x3SmallImage:
            return SummaryCardSmallImageVisualSource(card:card)
        case .SummaryCard4x3FullImage:
            return SummaryCardFullImageVisualSource(card:card,aspectRatio:0.75)
        case .ArticleCardNoImage:
            return ArticleCardNoImageVisualSource(card:card)
        case .ArticleCard4x3FullImage:
            return ArticleCardFullImageVisualSource(card:card, aspectRatio: 0.75)
        case .ArticleCard4x3SmallImage:
            return ArticleCardSmallImageVisualSource(card:card)
        case .Unknown:
            return PlaceholderCardVisualSource(card:card)
        }
    }

}