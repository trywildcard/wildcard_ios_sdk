//
//  PortraitEdge.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/5/14.
//
//

import Foundation

class PortraitEdge : LayoutDecisionEdge {
    
    override func evaluation(input:AnyObject)->Bool{
        // TODO: always take
        return true;
    }
}