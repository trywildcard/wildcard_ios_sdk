//
//  CardLayoutEngine.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/4/14.
//
//

import Foundation
import UIKit

class CardLayoutEngine{
    
    var root:LayoutDecisionNode
    
    init(root:LayoutDecisionNode){
        self.root = root
    }
    
    // swift doesn't support class constant variables yet, but you can do it in a struct
    class var sharedInstance : CardLayoutEngine {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : CardLayoutEngine? = nil
        }
        dispatch_once(&Static.onceToken) {
            let root = LayoutDecisionNode(description: "root")
            Static.instance = CardLayoutEngine(root:root)
            Static.instance?.buildDecisionTree()
        }
        return Static.instance!
    }
    
    func buildDecisionTree(){
        let cardTypeNode = LayoutDecisionNode(description: "Checking Card Type")
        let passThrough = DummyEdge(description:"Passthrough")
        root.addEdge(passThrough, destination: cardTypeNode)
        let linkCardNode = LayoutDecisionNode(description: "It's a video card")
        
        
        
        
    }
    
    func matchLayout(card:Card)->CardLayout{
        return CardLayout.Unknown
    }
    
}