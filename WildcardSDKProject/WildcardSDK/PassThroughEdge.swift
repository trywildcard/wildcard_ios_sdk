//
//  DummyEdge.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/5/14.
//
//

import Foundation

class PassThroughEdge : LayoutDecisionEdge {

    init(){
        super.init(description: "passthrough")
    }
    
    override func evaluation(input:AnyObject)->Bool{
        return true
    }
}