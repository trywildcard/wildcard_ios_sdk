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
            case .Unknown:
                return false
            case .Article:
                let articleCard = card as! ArticleCard
                return articleCard.primaryImageURL != nil
            case .Summary:
                let summaryCard = card as! SummaryCard
                return summaryCard.primaryImageURL != nil
            case .Video:
                let videoCard = card as! VideoCard
                return videoCard.posterImageUrl != nil
            case .Image:
                return true
            }
        }
        return false
    }
}