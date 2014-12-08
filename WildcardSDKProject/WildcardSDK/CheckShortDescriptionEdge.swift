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
    
    override func evaluation(input: AnyObject) -> Bool {
        if let card = input as? Card{
            switch card.type{
            case .Unknown:
                return false
            case .Article:
                let articleCard = card as ArticleCard
                if articleCard.abstractContent != nil{
                    return countElements(articleCard.abstractContent!) < 140
                }else{
                    return false
                }
            case .WebLink:
                let webLinkCard = card as WebLinkCard
                return countElements(webLinkCard.description) < 40
            }
        }
        return false
    }
    
}
