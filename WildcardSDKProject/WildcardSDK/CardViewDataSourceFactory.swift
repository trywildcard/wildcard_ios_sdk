//
//  CardViewDataSourceFactory.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/16/14.
//
//

import Foundation


class CardViewDataSourceFactory {
    
    /*
     * Creates a stock CardViewDataSource from a Wildcard layout
     */
    class func cardViewDataSourceFromLayout(layout:CardLayout, card:Card)->CardViewDataSource{
        switch(layout){
        case .BareCard:
            return BareBonesCardDataSource(card: card)
        case .WebLinkCardPortraitDefault:
            return SimpleDescriptionCardDataSource(card: card)
        case .WebLinkCardPortraitImageSmallFloatLeft:
            return ImageThumbnailFloatLeftDataSource(card: card)
        default:
            return BareBonesCardDataSource(card: card)
        }
    }
}