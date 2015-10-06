//
//  CardViewVisualSourceFactory.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation

class CardViewVisualSourceFactory {
    
    /// Returns a stock visual source from a given card layout.
    class func visualSourceFromLayout(layout:WCCardLayout, card:Card)->CardViewVisualSource{
        switch(layout){
        case .SummaryCardNoImage:
            let source = SummaryCardNoImageVisualSource(card:card)
            return source
        case .SummaryCardShort:
            let source = SummaryCardShortVisualSource(card:card)
            return source
        case .SummaryCardShortLeft:
            let source = SummaryCardShortLeftVisualSource(card:card)
            return source
        case .SummaryCardTall:
            let source = SummaryCardTallVisualSource(card:card,aspectRatio:0.75)
            return source
        case .SummaryCardImageOnly:
            let source = SummaryCardImageOnlyVisualSource(card:card,aspectRatio:0.5625)
            return source
        case .ArticleCardNoImage:
            let source = ArticleCardNoImageVisualSource(card:card)
            return source
        case .ArticleCardTall:
            let source = ArticleCardTallVisualSource(card:card, aspectRatio: 0.75)
            return source
        case .ArticleCardShort:
            let source = ArticleCardShortVisualSource(card:card)
            return source
        case .VideoCardShort:
            let source = VideoCardShortImageSource(card:card)
            return source
        case .VideoCardThumbnail:
            let source = VideoCardThumbnailImageSource(card:card)
            return source
        case .VideoCardShortFull:
            let source = VideoCardShortFullVisualSource(card:card)
            return source
        case .ImageCard4x3:
            let source = ImageCardTallVisualSource(card:card, aspectRatio:0.75)
            return source
        case .ImageCardAspectFit:
            let source = ImageCardTallVisualSource(card:card)
            return source
        case .ImageCardImageOnly:
            let source = ImageCardImageOnlyVisualSource(card:card, aspectRatio:0.75)
            return source
        case .SummaryCardTwitterProfile:
            let source = SummaryCardTwitterProfileVisualSource(card:card)
            return source
        case .SummaryCardTwitterTweet:
            let source = SummaryCardTwitterTweetVisualSource(card:card)
            return source
        case .Unknown:
            // shouldn't happen
            let source = SummaryCardNoImageVisualSource(card:card)
            return source
        }
    }
}