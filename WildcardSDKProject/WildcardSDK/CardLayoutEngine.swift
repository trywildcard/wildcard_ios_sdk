//
//  CardLayoutEngine.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/4/14.
//
//

import Foundation
import UIKit

public class CardLayoutEngine{
    
    var root:LayoutDecisionNode
    
    init(root:LayoutDecisionNode){
        self.root = root
    }
    
    // swift doesn't support class constant variables yet, but you can do it in a struct
    public class var sharedInstance : CardLayoutEngine {
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
        root.addEdge(PassThroughEdge(), destination: cardTypeNode)
        
        let linkCardNode = LayoutDecisionNode(description: "It's a web link card")
        cardTypeNode.addEdge(CardTypeEdge(cardType: "weblink"), destination: linkCardNode)
        
        let linkCardHasImageNode = LayoutDecisionNode(description: "Web link card has an image")
        let linkCardDefaultNode = LayoutDecisionNode(description: "LinkCardPortraitDefault", layout: CardLayout.LinkCardPortraitDefault)
        
        linkCardNode.addEdge(CheckImageEdge(), destination: linkCardHasImageNode)
        linkCardNode.addEdge(PassThroughEdge(), destination: linkCardDefaultNode)
        
        let linkCardFullImageNode = LayoutDecisionNode(description: "LinkCardPortraitImageFull", layout: CardLayout.LinkCardPortraitImageFull)
        let linkCardLongTitleNode = LayoutDecisionNode(description: "Web link card has a long title")
        linkCardHasImageNode.addEdge(CheckShortTitleEdge(), destination: linkCardFullImageNode)
        linkCardHasImageNode.addEdge(PassThroughEdge(), destination: linkCardLongTitleNode)
        
        let linkCardFloatLeftNode = LayoutDecisionNode(description: "LinkCardPortraitImageSmallFloatLeft", layout: CardLayout.LinkCardPortraitImageSmallFloatLeft)
        let linkCardFloatBottomNode = LayoutDecisionNode(description: "LinkCardPortraitImageSmallFloatBottom", layout: CardLayout.LinkCardPortraitImageSmallFloatBottom)
        linkCardLongTitleNode.addEdge(CheckShortDescriptionEdge(), destination: linkCardFloatLeftNode)
        linkCardLongTitleNode.addEdge(PassThroughEdge(), destination: linkCardFloatBottomNode)
    }
    
    public func matchLayout(card:Card)->CardLayout{
        var node:LayoutDecisionNode = root
        while(true){
            let followEdge:LayoutDecisionEdge? = node.edgeToFollow(card)
            
            // no edge to follow, return the layout at this node
            if(followEdge == nil){
                return  node.cardLayout
            // follow
            }else{
                node = followEdge!.post!
            }
        }
    }
    
}