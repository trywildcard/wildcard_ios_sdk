//
//  DummyEdge.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/5/14.
//
//

import Foundation

class DummyEdge : LayoutDecisionEdge {
    
    override func evaluation(input:AnyObject)->Bool{
        return true
    }
}