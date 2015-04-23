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
        let videoCardLandscapeNode = LayoutDecisionNode(description: "It's an video card landscape", layout: .VideoCardShort)
        let imageCardLandscapeNode = LayoutDecisionNode(description: "It's an image card landscape")
        landscapeNode.addEdge(CardTypeEdge(cardType: "summary"), destination: summaryCardLandscapeNode)
        landscapeNode.addEdge(CardTypeEdge(cardType: "article"), destination: articleCardLandscapeNode)
        
        // MARK: Landscape - Image Card
        landscapeNode.addEdge(CardTypeEdge(cardType: "image"), destination: imageCardLandscapeNode)
        
        let imageCardTitlePresentLandscape = LayoutDecisionNode(description: "Image card has title", layout: .ImageCard4x3)
        let imageCardTitleNotPresentLandscape = LayoutDecisionNode(description: "Image card doesn't have title", layout: .ImageCardImageOnly)
        imageCardLandscapeNode.addEdge(CheckTitlePresentEdge(), destination: imageCardTitlePresentLandscape)
        imageCardLandscapeNode.addEdge(PassThroughEdge(), destination: imageCardTitleNotPresentLandscape)
        
        // MARK: Landscape - Video Card
        landscapeNode.addEdge(CardTypeEdge(cardType: "video"), destination: videoCardLandscapeNode)
        
        // MARK: Landscape - Summary Card
        let summaryLandscapeHasImage = LayoutDecisionNode(description: "Summary card has an image", layout: .SummaryCardShort)
        let summaryLandscapeHasNoImage = LayoutDecisionNode(description: "Summary card has no image", layout: .SummaryCardNoImage)
        let summaryLandScapeTwitterProfile = LayoutDecisionNode(description: "Twitter Profile", layout:.SummaryCardTwitterProfile)
        let summaryLandScapeTwitterTweet = LayoutDecisionNode(description: "Twitter Tweet", layout:.SummaryCardTwitterTweet)
        
        summaryCardLandscapeNode.addEdge(CheckTwitterTweetEdge(), destination: summaryLandScapeTwitterTweet)
        summaryCardLandscapeNode.addEdge(CheckTwitterProfileEdge(), destination: summaryLandScapeTwitterProfile)
        summaryCardLandscapeNode.addEdge(CheckImageEdge(), destination: summaryLandscapeHasImage)
        summaryCardLandscapeNode.addEdge(PassThroughEdge(), destination: summaryLandscapeHasNoImage)
        
        // MARK: Landscape - Article Card
        let articleLandscapeHasImage = LayoutDecisionNode(description: "Article card has an image", layout: .ArticleCardShort)
        let articleLandscapeHasNoImage = LayoutDecisionNode(description: "Article card has no image", layout: .ArticleCardNoImage)
        
        articleCardLandscapeNode.addEdge(CheckImageEdge(), destination: articleLandscapeHasImage)
        articleCardLandscapeNode.addEdge(PassThroughEdge(), destination: articleLandscapeHasNoImage)
        
        // MARK: Portrait Decisions
        let summaryCardNode = LayoutDecisionNode(description: "It's a summary link card")
        let articleCardNode = LayoutDecisionNode(description: "It's an article card")
        let videoCardNode = LayoutDecisionNode(description: "It's an video card", layout: .VideoCardShort)
        let imageCardNode = LayoutDecisionNode(description: "It's an image card")
        portraitNode.addEdge(CardTypeEdge(cardType: "summary"), destination: summaryCardNode)
        portraitNode.addEdge(CardTypeEdge(cardType: "article"), destination: articleCardNode)
        
        // MARK: Portrait - Image Card
        portraitNode.addEdge(CardTypeEdge(cardType: "image"), destination: imageCardNode)
        
        let imageCardTitlePresent = LayoutDecisionNode(description: "Image card has title")
        let imageCardTitleNotPresent = LayoutDecisionNode(description: "Image card doesn't have title", layout: .ImageCardImageOnly)
        imageCardNode.addEdge(CheckTitlePresentEdge(), destination: imageCardTitlePresent)
        imageCardNode.addEdge(PassThroughEdge(), destination: imageCardTitleNotPresent)
        
        let imageCardAspectPresent = LayoutDecisionNode(description: "Image card has aspect ratio", layout: .ImageCardAspectFit)
        let imageCardAspectNotPresent = LayoutDecisionNode(description: "Image card doesn't have aspect ratio", layout: .ImageCard4x3)
        imageCardTitlePresent.addEdge(CheckAspectRatioPresentEdge(), destination: imageCardAspectPresent)
        imageCardTitlePresent.addEdge(PassThroughEdge(), destination: imageCardAspectNotPresent)
        
        // MARK: Portrait - Video Card
        portraitNode.addEdge(CardTypeEdge(cardType: "video"), destination: videoCardNode)
        
        // MARK: Portrait - Article Card
        let articleCardHasImage = LayoutDecisionNode(description: "Article card has an image", layout: .ArticleCardTall)
        let articleCardHasNoImage = LayoutDecisionNode(description: "Article card has no image", layout: .ArticleCardNoImage)
        articleCardNode.addEdge(CheckImageEdge(), destination: articleCardHasImage)
        articleCardNode.addEdge(PassThroughEdge(), destination: articleCardHasNoImage)
        
        // MARK: Portrait - Summary Card
        let summaryCardHasImage = LayoutDecisionNode(description: "Summary card has image", layout: .SummaryCardTall)
        let summaryCardHasNoImage = LayoutDecisionNode(description: "Summary card has no image", layout: .SummaryCardNoImage)
        let summaryCardTwitterProfile = LayoutDecisionNode(description: "Twitter Profile", layout:.SummaryCardTwitterProfile)
        let summaryCardTwitterTweet = LayoutDecisionNode(description: "Twitter Tweet", layout:.SummaryCardTwitterTweet)
        
        summaryCardNode.addEdge(CheckTwitterTweetEdge(), destination: summaryCardTwitterTweet)
        summaryCardNode.addEdge(CheckTwitterProfileEdge(), destination: summaryCardTwitterProfile)
        summaryCardNode.addEdge(CheckImageEdge(), destination: summaryCardHasImage)
        summaryCardNode.addEdge(PassThroughEdge(), destination: summaryCardHasNoImage)
        
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