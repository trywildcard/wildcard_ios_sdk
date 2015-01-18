//
//  CardViewVisualSourceFactory.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation


class CardViewVisualSourceFactory {
    
    /**
    Creates a stock CardViewVisualSource from a Wildcard layout type
    */
    class func cardViewVisualSourceFromLayout(layout:CardLayout, card:Card)->CardViewVisualSource{
        switch(layout){
        case .Unknown:
            return BareBonesCardVisualSource(card: card)
        case .SummaryCardPortraitDefault:
            return SimpleDescriptionCardVisualSource(card: card)
        case .SummaryCardPortraitImageSmallFloatLeft:
            return ImageThumbnailFloatLeftVisualSource(card: card)
        case .SummaryCardPortraitImageFull:
            return ImageFullFloatBottomVisualSource(card: card)
        case .ArticleCardPortraitImage,
        .ArticleCardPortraitNoImage:
            return SquareArticleVisualSource(card:card)
        case .MaximizedFullWebView:
            return MaximizedArticleVisualSource(card:card)
        }
    }
}