//
//  UIViewControllerPresentations.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/9/14.
//
//

import Foundation

/*
 * UIViewController extensions for various stock card presentations
 */
public extension UIViewController{
    
    public func presentCard(card:Card){
        let layoutToUse = CardLayoutEngine.sharedInstance.matchLayout(card)
        let datasource = CardViewVisualSourceFactory.cardViewVisualSourceFromLayout(layoutToUse, card: card)
        presentCard(card, customVisualSource: datasource)
    }

    public func presentCard(card:Card, customVisualSource:CardViewVisualSource){
        let stockModal = StockModalCardViewController()
        stockModal.modalPresentationStyle = .Custom
        stockModal.transitioningDelegate = stockModal
        stockModal.modalPresentationCapturesStatusBarAppearance = true
        stockModal.presentedCard = card
        stockModal.cardVisualSource = customVisualSource
        presentViewController(stockModal, animated: true, completion: nil)
    }
    
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
    
    public func maximizeCardView(cardView:CardView){
        
        let viewController = StockMaximizedCardViewController()
        viewController.previousCardView = cardView
        viewController.initialCardVisualSource = cardView.visualSource
        viewController.modalPresentationStyle = .Custom
        viewController.transitioningDelegate = viewController
        viewController.modalPresentationCapturesStatusBarAppearance = true
        viewController.maximizedCard = cardView.backingCard
        
        viewController.maximizedCardDataSource = MaximizedArticleVisualSource(card:cardView.backingCard)
        
        let initialFrame = view.convertRect(cardView.frame, fromView: cardView.superview)
        viewController.initialCardFrame = initialFrame
        
        presentViewController(viewController, animated: true, completion: nil)
    }
}