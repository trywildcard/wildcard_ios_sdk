//
//  CheckShortTitleEdge.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/7/14.
//
//

import Foundation

class CheckShortTitleEdge : LayoutDecisionEdge{
    
    init(){
        super.init(description:"Does this card have a short title?")
    }
    
    override func evaluation(input: AnyObject) -> Bool {
        if let card = input as? Card{
            switch card.type{
            case .Unknown:
                return false
            case .Article:
                let articleCard = card as ArticleCard
                return countElements(articleCard.title) < 40
            case .WebLink:
                let webLinkCard = card as WebLinkCard
                return countElements(webLinkCard.title) < 40
            }
        }
        return false
    }
    
    
}