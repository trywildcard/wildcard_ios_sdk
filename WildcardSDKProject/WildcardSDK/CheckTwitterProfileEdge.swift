//
//  CheckTwitterProfileEdge.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 4/23/15.
//
//

import Foundation

class CheckTwitterProfileEdge : LayoutDecisionEdge
{
    init(){
        super.init(description: "Twitter Profile?")
    }
    
    override func evaluation(input: AnyObject) -> Bool {
        if let card = input as? SummaryCard{
            return card.webUrl.isTwitterProfileURL()
        }else{
            return false
        }
    }
}