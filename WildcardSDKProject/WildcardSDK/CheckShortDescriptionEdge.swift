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
    
    let DESCRIPTION_THRESHOLD = 100
    
    override func evaluation(input: AnyObject) -> Bool {
        if let card = input as? Card{
            switch card.type{
            case .Unknown:
                return false
            case .Article:
                let articleCard = card as! ArticleCard
                if articleCard.abstractContent != nil{
                    return (articleCard.abstractContent!).characters.count < DESCRIPTION_THRESHOLD
                }else{
                    return false
                }
            case .Summary:
                let summaryCard = card as! SummaryCard
                return summaryCard.description.characters.count < DESCRIPTION_THRESHOLD
            case .Video:
                let videoCard = card as! VideoCard
                if videoCard.abstractContent != nil{
                    return (videoCard.abstractContent!).characters.count < DESCRIPTION_THRESHOLD
                }else{
                    return false
                }
            case .Image:
                let imageCard = card as! ImageCard
                if imageCard.imageCaption != nil{
                    return (imageCard.imageCaption!).characters.count < DESCRIPTION_THRESHOLD
                }else{
                    return false
                }
            }
        }
        return false
    }
    
}
