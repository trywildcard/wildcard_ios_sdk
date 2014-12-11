//
//  CardViewRenderer.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/8/14.
//
//

import Foundation
import UIKit

public class CardViewRenderer
{
    // MARK: Public
    
    // Renders a CardView from a Card w/ best fit layout
    public class func renderViewFromCard(card:Card)->CardView?{
        let layoutToUse = CardLayoutEngine.sharedInstance.matchLayout(card)
        return CardViewRenderer.renderViewFromCard(card, layout:layoutToUse)
    }
    
    // Renders a CardView from a Card w/ explicit layout
    public class func renderViewFromCard(card:Card, layout:CardLayout)->CardView?{
        
        // brand new card view
        var newCardView = CardView(frame: CGRectZero)
        
        // generate content view with appropriate layout
        let cardContentView = CardContentView.generateContentViewFromLayout(layout)
        
        // initialize content view
        newCardView.initializeContentView(cardContentView)
        
        // update content for card
        cardContentView.updateViewForCard(card)
        
        // any last minute things to do to card view before returning to user
        newCardView.finalizeCard()
        
        return newCardView
    }

    
}