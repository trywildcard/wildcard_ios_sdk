//
//  CardViewVisualSourceFactory.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

class CardViewVisualSourceFactory {
    
    class func visualSourceFromLayout(layout:WCTemplate, card:Card)->CardViewVisualSource{
        switch(layout){
        case .SummaryCardNoImage:
            return SummaryCardNoImageVisualSource(card:card)
        case .SummaryCard4x3FullImage:
            return SummaryCardFullImageVisualSource(card:card,aspectRatio:0.75)
        case .SummaryCard4x3FloatRightImage:
            return SummaryCard4x3FloatRightImageVisualSource(card:card)
        case .SummaryCard4x3FloatRightImageTextWrap:
            return SummaryCard4x3FloatRightImageTextWrapVisualSource(card:card)
        case .ArticleCardNoImage:
            return ArticleCardNoImageVisualSource(card:card)
        case .ArticleCard4x3FullImage:
            return ArticleCardFullImageVisualSource(card:card, aspectRatio: 0.75)
        case .ArticleCard4x3FloatRightImageTextWrap:
            return ArticleCard4x3FloatRightImageTextWrapVisualSource(card:card)
        default:
            return PlaceholderCardVisualSource(card: card)
        }
    }

}