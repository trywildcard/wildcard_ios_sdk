//
//  PortraitEdge.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/5/14.
//
//

import Foundation
import UIKit

class PortraitEdge : LayoutDecisionEdge {
    
    init(){
        super.init(description: "portrait")
    }
    
    override func evaluation(input:AnyObject)->Bool{
        // TODO: always take
        return true;
    }
}