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
        let landscapeNode = LayoutDecisionNode(description: "Using landscape layouts")
        let portraitNode = LayoutDecisionNode(description: "Using portrait layouts")
        root.addEdge(PortraitEdge(), destination: portraitNode)
        root.addEdge(LandscapeEdge(), destination: landscapeNode)
        
        let cardTypeNode = LayoutDecisionNode(description: "Checking Card Type")
        portraitNode.addEdge(PassThroughEdge(), destination: cardTypeNode)
        
        let linkCardNode = LayoutDecisionNode(description: "It's a web link card")
        let articleCardNode = LayoutDecisionNode(description: "It's an article card")
        cardTypeNode.addEdge(CardTypeEdge(cardType: "weblink"), destination: linkCardNode)
        cardTypeNode.addEdge(CardTypeEdge(cardType: "article"), destination: articleCardNode)
        
        // article card layouts
        let articleCardHasImage = LayoutDecisionNode(description: "Article card has an image", layout:CardLayout.ArticleCardPortraitImage)
        let articleCardHasNoImage = LayoutDecisionNode(description: "Article card has no image", layout: CardLayout.ArticleCardPortraitNoImage)
        articleCardNode.addEdge(CheckImageEdge(), destination: articleCardHasImage)
        articleCardNode.addEdge(PassThroughEdge(), destination: articleCardHasNoImage)
        
        // web card layouts
        let linkCardHasImageNode = LayoutDecisionNode(description: "Web link card has an image")
        let linkCardDefaultNode = LayoutDecisionNode(description: "LinkCardPortraitDefault", layout: CardLayout.WebLinkCardPortraitDefault)
        
        linkCardNode.addEdge(CheckImageEdge(), destination: linkCardHasImageNode)
        linkCardNode.addEdge(PassThroughEdge(), destination: linkCardDefaultNode)
        
        let linkCardFullImageNode = LayoutDecisionNode(description: "LinkCardPortraitImageFull", layout: CardLayout.WebLinkCardPortraitImageFull)
        let linkCardLongTitleNode = LayoutDecisionNode(description: "Web link card has a long title")
        linkCardHasImageNode.addEdge(CheckShortTitleEdge(), destination: linkCardFullImageNode)
        linkCardHasImageNode.addEdge(PassThroughEdge(), destination: linkCardLongTitleNode)
        
        let linkCardFloatLeftNode = LayoutDecisionNode(description: "LinkCardPortraitImageSmallFloatLeft", layout: CardLayout.WebLinkCardPortraitImageSmallFloatLeft)
        let linkCardFloatBottomNode = LayoutDecisionNode(description: "LinkCardPortraitImageSmallFloatBottom", layout: CardLayout.WebLinkCardPortraitImageFull)
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