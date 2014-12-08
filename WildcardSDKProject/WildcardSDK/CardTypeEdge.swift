//
//  CardTypeEdge.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/7/14.
//
//

import Foundation


class CardTypeEdge : LayoutDecisionEdge
{
    let cardType:String
    
    init(cardType:String){
        self.cardType = cardType
        super.init(description: "Card Type is " + cardType + "?")
    }
    
    override func evaluation(input: AnyObject) -> Bool {
        if let card = input as? Card{
            return card.cardType == cardType
        }else{
            return false
        }
    }
}
