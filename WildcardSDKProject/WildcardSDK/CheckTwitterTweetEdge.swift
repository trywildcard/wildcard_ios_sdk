//
//  CheckTwitterTweetEdge.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 4/23/15.
//
//

import Foundation

class CheckTwitterTweetEdge : LayoutDecisionEdge
{
    init(){
        super.init(description: "Twitter Tweet?")
    }
    
    override func evaluation(input: AnyObject) -> Bool {
        if let card = input as? SummaryCard{
            return card.webUrl.isTwitterTweetURL()
        }else{
            return false
        }
    }
}