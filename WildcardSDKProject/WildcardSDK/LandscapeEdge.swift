//
//  LandscapeEdge.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/5/14.
//
//

import Foundation

class LandscapeEdge : LayoutDecisionEdge {
    
    init(){
        super.init(description: "landscape")
    }
    
    override func evaluation(input:AnyObject)->Bool{
        let bounds = UIScreen.mainScreen().bounds
        return bounds.width > bounds.height
    }
}