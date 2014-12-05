//
//  ArticleCardEdge.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/5/14.
//
//

import Foundation

class ArticleCardEdge : LayoutDecisionEdge {
    
    override func evaluation(input:AnyObject)->Bool{
        if input is ArticleCard{
            return true
        }else{
            return false
        }
    }
}