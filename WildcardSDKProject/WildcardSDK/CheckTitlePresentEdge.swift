//
//  CheckTitlePresentEdge.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 3/31/15.
//
//

import Foundation

class CheckTitlePresentEdge : LayoutDecisionEdge
{
    
    init(){
        super.init(description:"Title available")
    }
    
    override func evaluation(input: AnyObject) -> Bool {
        if let card = input as? Card{
            switch card.type{
            case .Image:
                let imageCard = card as! ImageCard
                if imageCard.title != nil{
                    return true
                }else{
                    return false
                }
            default:
                return true
            }
        }
        return false
    }
}