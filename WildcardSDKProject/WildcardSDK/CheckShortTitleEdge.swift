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
                let articleCard = card as! ArticleCard
                return articleCard.title.characters.count < TITLE_THRESHOLD
            case .Summary:
                let summaryCard = card as! SummaryCard
                return summaryCard.title.characters.count < TITLE_THRESHOLD
            case .Video:
                let videoCard = card as! VideoCard
                return videoCard.title.characters.count < TITLE_THRESHOLD
            case .Image:
                let imageCard = card as! ImageCard
                if imageCard.title != nil {
                    return (imageCard.title!).characters.count < TITLE_THRESHOLD
                }else{
                    return false
                }
            }
        }
        return false
    }
    
    
}