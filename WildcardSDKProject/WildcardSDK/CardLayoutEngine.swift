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
        
        let summaryCardNode = LayoutDecisionNode(description: "It's a summary link card")
        let articleCardNode = LayoutDecisionNode(description: "It's an article card")
        cardTypeNode.addEdge(CardTypeEdge(cardType: "summary"), destination: summaryCardNode)
        cardTypeNode.addEdge(CardTypeEdge(cardType: "article"), destination: articleCardNode)
        
        // MARK: Article Card Layout Decisions
        let articleCardHasImage = LayoutDecisionNode(description: "Article card has an image")
        let articleCardHasNoImage = LayoutDecisionNode(description: "Article card has no image", layout: WCTemplate.ArticleCardNoImage)
        articleCardNode.addEdge(CheckImageEdge(), destination: articleCardHasImage)
        articleCardNode.addEdge(PassThroughEdge(), destination: articleCardHasNoImage)
        
        let articleCardShortTitle = LayoutDecisionNode(description: "Article card has short title", layout:.ArticleCard4x3FullImage)
        let articleCardLongTitle = LayoutDecisionNode(description: "Article card has long title", layout: .ArticleCard4x3FloatRightImageTextWrap)
        articleCardHasImage.addEdge(CheckShortTitleEdge(), destination: articleCardShortTitle);
        articleCardHasImage.addEdge(PassThroughEdge(), destination: articleCardLongTitle);
        
        // MARK: Summary Card Layout Decisions
        let summaryCardHasImage = LayoutDecisionNode(description: "Summary card has image")
        let summaryCardHasNoImage = LayoutDecisionNode(description: "Summary card has no image", layout: .SummaryCardNoImage)
        
        summaryCardNode.addEdge(CheckImageEdge(), destination: summaryCardHasImage)
        summaryCardNode.addEdge(PassThroughEdge(), destination: summaryCardHasNoImage)
        
        let summaryCardShortTitle = LayoutDecisionNode(description: "Summary card has short title", layout:.SummaryCard4x3FloatRightImage)
        let summaryCardLongTitle = LayoutDecisionNode(description: "Summary card has long title")
        summaryCardHasImage.addEdge(CheckShortTitleEdge(), destination: summaryCardShortTitle)
        summaryCardHasImage.addEdge(PassThroughEdge(), destination: summaryCardLongTitle)
        
        let summaryCardShortDescription = LayoutDecisionNode(description: "Summary card has short desc", layout:.SummaryCard4x3FullImage)
        let summaryCardLongDescription = LayoutDecisionNode(description: "Summary card has long desc", layout: .SummaryCard4x3FloatRightImageTextWrap)
        summaryCardLongTitle.addEdge(CheckShortDescriptionEdge(), destination: summaryCardShortDescription)
        summaryCardLongTitle.addEdge(PassThroughEdge(), destination: summaryCardLongDescription)
    }
    
    public func matchLayout(card:Card)->WCTemplate{
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