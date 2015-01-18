//
//  CheckImageEdge.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/7/14.
//
//

import Foundation

class CheckImageEdge : LayoutDecisionEdge
{
    init(){
        super.init(description:"Is image available?")
    }
    
    override func evaluation(input: AnyObject) -> Bool {
        if let card = input as? Card{
            switch card.type{
            case .WCCardTypeUnknown:
                return false
            case .WCCardTypeArticle:
                let articleCard = card as ArticleCard
                return articleCard.primaryImageURL != nil
            case .WCCardTypeSummary:
                let webLinkCard = card as SummaryCard
                return webLinkCard.imageUrl != nil
            }
        }
        return false
    }
}