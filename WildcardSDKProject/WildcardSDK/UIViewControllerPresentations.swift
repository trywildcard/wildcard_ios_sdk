//
//  UIViewControllerPresentations.swift
//  WildcardSDKProject
//
//  Created by David Xiang on 12/9/14.
//
//

import Foundation

/*
* UIViewController extensions for various card presentations
*/
public extension UIViewController{
    
    public func presentCard(card:Card){
        let modalViewController = ModalCardViewController()
        
        // snap shot current view to use as background in modal
        let snapShot:UIView = view.snapshotViewAfterScreenUpdates(false)
        modalViewController.view.insertSubview(snapShot, atIndex:0)
        snapShot.constrainToSuperViewEdges()    
        
        // prepare for presentation
        modalViewController.presentingControllerBackgroundView = snapShot
        modalViewController.blurredOverlayView = snapShot.addBlurOverlay(UIBlurEffectStyle.Dark)
        modalViewController.blurredOverlayView!.alpha = 0
        modalViewController.presentedCard = card
        
        presentViewController(modalViewController, animated: false, completion: nil)
    }
    
    public func presentCardsAsStack(cards:[Card]){
        
        if(cards.count < 3){
            println("Can not present Card Stack with less than 3 Cards.")
            return
        }
        
        let modalStackViewController = ModalCardStackViewController()
        
        // snap shot current view to use as background in modal
        let snapShot:UIView = view.snapshotViewAfterScreenUpdates(false)
        modalStackViewController.view.insertSubview(snapShot, atIndex:0)
        snapShot.constrainToSuperViewEdges()
        
        // prepare for presentation
        modalStackViewController.presentingControllerBackgroundView = snapShot
        modalStackViewController.blurredOverlayView = snapShot.addBlurOverlay(UIBlurEffectStyle.Dark)
        modalStackViewController.blurredOverlayView!.alpha = 0
        modalStackViewController.cards = cards
        
        presentViewController(modalStackViewController, animated: false, completion: nil)
        
    }
}