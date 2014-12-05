//
//  LinkCardEdge.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/5/14.
//
//

import Foundation

class LinkCardEdge : LayoutDecisionEdge {
    
    override func evaluation(input:AnyObject)->Bool{
        if input is LinkCard{
            return true
        }else{
            return false
        }
    }
}