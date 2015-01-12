//
//  UIViewControllerPresentations.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/9/14.
//
//

import Foundation

public extension UIViewController{
    
    /**
    Presents a Card modally. The visual source for the Card will be automatically selected.
    */
    public func presentCard(card:Card){
        let layoutToUse = CardLayoutEngine.sharedInstance.matchLayout(card)
        let datasource = CardViewVisualSourceFactory.cardViewVisualSourceFromLayout(layoutToUse, card: card)
        presentCard(card, customVisualSource: datasource)
    }

    /**
    Presents a Card modally with a custom visual source.
    */
    public func presentCard(card:Card, customVisualSource:CardViewVisualSource){
        let stockModal = StockModalCardViewController()
        stockModal.modalPresentationStyle = .Custom
        stockModal.transitioningDelegate = stockModal
        stockModal.modalPresentationCapturesStatusBarAppearance = true
        stockModal.presentedCard = card
        stockModal.cardVisualSource = customVisualSource
        presentViewController(stockModal, animated: true, completion: nil)
    }
    
    /**
    Presents an array of Cards as a swipe-able Stack
    */
    public func presentCardsAsStack(cards:[Card]){
        if(cards.count < 4){
            println("Can not present Deck with less than 4 Cards.")
            return
        }
        let deckController = StockModalDeckViewController()
        deckController.modalPresentationStyle = .Custom
        deckController.transitioningDelegate = deckController
        deckController.modalPresentationCapturesStatusBarAppearance = true
        deckController.cards = cards
        presentViewController(deckController, animated: true, completion: nil)
    }
    
    /**
    Presents a view controller showing a maximized Article Card view for a full reading experience. A Card View with a backing Article Card must be provided.
    
    This will use a stock Wildcard maximized visual source for Article Cards.
    */
    public func maximizeArticleCard(cardView:CardView){
        if(cardView.backingCard.type != .Article){
            println("The backing Card for this CardView is not an Article Card!")
            return
        }
        let maximizeVisualSource = MaximizedArticleVisualSource(card: cardView.backingCard)
        maximizeCardView(cardView, visualsource: maximizeVisualSource)
    }
    
    /**
    Presents a view controller of a maximized Card with the given maximized visual source.
    */
    public func maximizeCardView(cardView:CardView, visualsource:MaximizedCardViewVisualSource){
        
        let viewController = StockMaximizedCardViewController()
        viewController.presentingCardView = cardView
        viewController.initialCardVisualSource = cardView.visualSource
        viewController.modalPresentationStyle = .Custom
        viewController.transitioningDelegate = viewController
        viewController.modalPresentationCapturesStatusBarAppearance = true
        viewController.maximizedCard = cardView.backingCard
        viewController.maximizedCardVisualSource = visualsource
        
        let initialFrame = view.convertRect(cardView.frame, fromView: cardView.superview)
        viewController.initialCardFrame = initialFrame
        
        if( Utilities.validateMaximizeVisualSource(visualsource)){
            presentViewController(viewController, animated: true, completion: nil)
        }else{
            println("Can not maximize CardView due to dimension mismatch")
        }
    }
}