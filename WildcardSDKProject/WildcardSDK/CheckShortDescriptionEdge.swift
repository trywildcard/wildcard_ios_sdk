//
//  CheckShortDescriptionEdge.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/8/14.
//
//

import Foundation

class CheckShortDescriptionEdge : LayoutDecisionEdge
{
    init(){
        super.init(description:"Does this card have a short description?")
    }
    
    let DESCRIPTION_THRESHOLD = 140
    
    override func evaluation(input: AnyObject) -> Bool {
        if let card = input as? Card{
            switch card.type{
            case .Unknown:
                return false
            case .Article:
                let articleCard = card as ArticleCard
                if articleCard.abstractContent != nil{
                    return countElements(articleCard.abstractContent!) < DESCRIPTION_THRESHOLD
                }else{
                    return false
                }
            case .Summary:
                let webLinkCard = card as SummaryCard
                return countElements(webLinkCard.description) < DESCRIPTION_THRESHOLD
            }
        }
        return false
    }
    
}
