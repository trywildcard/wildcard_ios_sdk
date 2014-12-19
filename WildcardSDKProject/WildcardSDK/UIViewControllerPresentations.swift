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
        let datasource = CardViewDataSourceFactory.cardViewDataSourceFromLayout(layoutToUse, card: card)
        presentCard(card, customDatasource: datasource)
    }

    public func presentCard(card:Card, customDatasource:CardViewDataSource){
        let stockModal = StockModalCardViewController()
        stockModal.modalPresentationStyle = .Custom
        stockModal.transitioningDelegate = stockModal
        stockModal.modalPresentationCapturesStatusBarAppearance = true
        stockModal.presentedCard = card
        stockModal.cardDataSource = customDatasource
        presentViewController(stockModal, animated: true, completion: nil)
    }
    
    public func presentCardsAsStack(cards:[Card]){
        if(cards.count < 5){
            println("Can not present Deck with less than 5 Cards.")
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
        
        let viewController = ModalMaximizedCardViewController()
        
        let maximizedDataSource = MaximizedArticleDataSource(card:cardView.backingCard)
        
        let convertedCardFrame = view.convertRect(cardView.frame, fromView: cardView.superview)
        viewController.initialCardFrame = convertedCardFrame
        viewController.initialCardDataSource = cardView.datasource
        viewController.maximizedCardDataSource = maximizedDataSource
        viewController.maximizedCard = cardView.backingCard
        
        // snap shot current view to use as background in modal
        let snapShot:UIView = view.snapshotViewAfterScreenUpdates(false)
        viewController.view.insertSubview(snapShot, atIndex:0)
        snapShot.constrainToSuperViewEdges()
        
        // prepare for presentation
        viewController.presentingControllerBackgroundView = snapShot
        viewController.blurredOverlayView = snapShot.addBlurOverlay(UIBlurEffectStyle.Dark)
        viewController.blurredOverlayView!.alpha = 0
        
        presentViewController(viewController, animated: false, completion: nil)
    }
}