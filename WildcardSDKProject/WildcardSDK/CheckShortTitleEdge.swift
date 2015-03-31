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
    
    let TITLE_THRESHOLD = 40
    
    override func evaluation(input: AnyObject) -> Bool {
        if let card = input as? Card{
            switch card.type{
            case .Unknown:
                return false
            case .Article:
                let articleCard = card as ArticleCard
                return countElements(articleCard.title) < TITLE_THRESHOLD
            case .Summary:
                let summaryCard = card as SummaryCard
                return countElements(summaryCard.title) < TITLE_THRESHOLD
            case .Video:
                let videoCard = card as VideoCard
                return countElements(videoCard.title) < TITLE_THRESHOLD
            case .Image:
                let imageCard = card as ImageCard
                return countElements(imageCard.title) < TITLE_THRESHOLD
            }
        }
        return false
    }
    
    
}