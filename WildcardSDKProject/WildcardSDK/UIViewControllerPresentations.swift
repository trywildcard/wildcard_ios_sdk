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
        let modalViewController = ModalCardViewController()
        
        // snap shot current view to use as background in modal
        let snapShot:UIView = view.snapshotViewAfterScreenUpdates(false)
        modalViewController.view.insertSubview(snapShot, atIndex:0)
        snapShot.verticallyCenterToSuperView(0)
        snapShot.horizontallyCenterToSuperView(0)
        snapShot.constrainToSuperViewEdges()
        
        // prepare for presentation
        modalViewController.presentingControllerBackgroundView = snapShot
        modalViewController.blurredOverlayView = snapShot.addBlurOverlay(UIBlurEffectStyle.Dark)
        modalViewController.blurredOverlayView!.alpha = 0
        modalViewController.presentedCard = card
        modalViewController.cardDataSource = customDatasource
        
        presentViewController(modalViewController, animated: false, completion: nil)
    }
    
    public func presentCardsAsStack(cards:[Card]){
        
        if(cards.count < 3){
            println("Can not present Card Stack with less than 3 Cards.")
            return
        }
        
        let modalStackViewController = ModalCardStackViewController()
        modalStackViewController.cards = cards
        
        // snap shot current view to use as background in modal
        let snapShot:UIView = view.snapshotViewAfterScreenUpdates(false)
        modalStackViewController.view.insertSubview(snapShot, atIndex:0)
        snapShot.constrainToSuperViewEdges()
        
        // prepare for presentation
        modalStackViewController.presentingControllerBackgroundView = snapShot
        modalStackViewController.blurredOverlayView = snapShot.addBlurOverlay(UIBlurEffectStyle.Dark)
        modalStackViewController.blurredOverlayView!.alpha = 0
        
        presentViewController(modalStackViewController, animated: false, completion: nil)
        
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