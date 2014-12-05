//
//  LayoutDecisionEdge.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/4/14.
//
//

import Foundation

class LayoutDecisionEdge{
    
    let description:String
    var pre:LayoutDecisionNode?
    var post:LayoutDecisionNode?
    
    init(description:String){
        self.description = description
    }
    
    /* All derived edge classes should override */
    func evaluation(input:AnyObject)->Bool{
        return false
    }
}