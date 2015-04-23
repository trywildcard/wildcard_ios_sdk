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
            var source = SummaryCardNoImageVisualSource(card:card)
            return source
        case .SummaryCardShort:
            var source = SummaryCardShortVisualSource(card:card)
            return source
        case .SummaryCardShortLeft:
            var source = SummaryCardShortLeftVisualSource(card:card)
            return source
        case .SummaryCardTall:
            var source = SummaryCardTallVisualSource(card:card,aspectRatio:0.75)
            return source
        case .SummaryCardImageOnly:
            var source = SummaryCardImageOnlyVisualSource(card:card,aspectRatio:0.5625)
            return source
        case .ArticleCardNoImage:
            var source = ArticleCardNoImageVisualSource(card:card)
            return source
        case .ArticleCardTall:
            var source = ArticleCardTallVisualSource(card:card, aspectRatio: 0.75)
            return source
        case .ArticleCardShort:
            var source = ArticleCardShortVisualSource(card:card)
            return source
        case .VideoCardShort:
            var source = VideoCardShortImageSource(card:card)
            return source
        case .VideoCardThumbnail:
            var source = VideoCardThumbnailImageSource(card:card)
            return source
        case .VideoCardShortFull:
            var source = VideoCardShortFullVisualSource(card:card)
            return source
        case .ImageCard4x3:
            var source = ImageCardTallVisualSource(card:card, aspectRatio:0.75)
            return source
        case .ImageCardAspectFit:
            var source = ImageCardTallVisualSource(card:card)
            return source
        case .ImageCardImageOnly:
            var source = ImageCardImageOnlyVisualSource(card:card, aspectRatio:0.75)
            return source
        case .SummaryCardTwitterProfile:
            var source = SummaryCardTwitterProfileVisualSource(card:card)
            return source
        case .SummaryCardTwitterTweet:
            var source = SummaryCardTwitterTweetVisualSource(card:card)
            return source
        case .Unknown:
            // shouldn't happen
            var source = SummaryCardNoImageVisualSource(card:card)
            return source
        }
    }
}