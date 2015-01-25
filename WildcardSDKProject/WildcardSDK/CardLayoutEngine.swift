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
        
        // MARK: Landscape Decisions
        let summaryCardLandscapeNode = LayoutDecisionNode(description: "It's a summary card landscape")
        let articleCardLandscapeNode = LayoutDecisionNode(description: "It's an article card landscape")
        landscapeNode.addEdge(CardTypeEdge(cardType: "summary"), destination: summaryCardLandscapeNode)
        landscapeNode.addEdge(CardTypeEdge(cardType: "article"), destination: articleCardLandscapeNode)
        
        // MARK: Landscape - Summary Card
        let summaryLandscapeHasImage = LayoutDecisionNode(description: "Summary card has an image", layout: .SummaryCardLandscapeImage)
        let summaryLandscapeHasNoImage = LayoutDecisionNode(description: "Summary card has no image", layout: .SummaryCardNoImage)
        
        summaryCardLandscapeNode.addEdge(CheckImageEdge(), destination: summaryLandscapeHasImage)
        summaryCardLandscapeNode.addEdge(PassThroughEdge(), destination: summaryLandscapeHasNoImage)
        
        // MARK: Landscape - Article Card
        let articleLandscapeHasImage = LayoutDecisionNode(description: "Article card has an image", layout: .ArticleCard4x3FloatRightImageTextWrap)
        let articleLandscapeHasNoImage = LayoutDecisionNode(description: "Article card has no image", layout: .ArticleCardNoImage)
        
        articleCardLandscapeNode.addEdge(CheckImageEdge(), destination: articleLandscapeHasImage)
        articleCardLandscapeNode.addEdge(PassThroughEdge(), destination: articleLandscapeHasNoImage)
        
        // MARK: Portrait Decisions
        let summaryCardNode = LayoutDecisionNode(description: "It's a summary link card")
        let articleCardNode = LayoutDecisionNode(description: "It's an article card")
        portraitNode.addEdge(CardTypeEdge(cardType: "summary"), destination: summaryCardNode)
        portraitNode.addEdge(CardTypeEdge(cardType: "article"), destination: articleCardNode)
        
        // MARK: Portrait - Article Card
        let articleCardHasImage = LayoutDecisionNode(description: "Article card has an image", layout: .ArticleCard4x3FullImage)
        let articleCardHasNoImage = LayoutDecisionNode(description: "Article card has no image", layout: .ArticleCardNoImage)
        articleCardNode.addEdge(CheckImageEdge(), destination: articleCardHasImage)
        articleCardNode.addEdge(PassThroughEdge(), destination: articleCardHasNoImage)
        
        // MARK: Portrait - Summary Card
        let summaryCardHasImage = LayoutDecisionNode(description: "Summary card has image")
        let summaryCardHasNoImage = LayoutDecisionNode(description: "Summary card has no image", layout: .SummaryCardNoImage)
        
        summaryCardNode.addEdge(CheckImageEdge(), destination: summaryCardHasImage)
        summaryCardNode.addEdge(PassThroughEdge(), destination: summaryCardHasNoImage)
        
        let summaryCardShortTitle = LayoutDecisionNode(description: "Summary card has short title", layout:.SummaryCard4x3FloatRightImage)
        let summaryCardLongTitle = LayoutDecisionNode(description: "Summary card has long title", layout:.SummaryCard4x3FullImage)
        summaryCardHasImage.addEdge(CheckShortTitleEdge(), destination: summaryCardShortTitle)
        summaryCardHasImage.addEdge(PassThroughEdge(), destination: summaryCardLongTitle)
    }
    
    public func matchLayout(card:Card)->WCCardLayout{
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